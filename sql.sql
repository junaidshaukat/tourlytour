DROP FUNCTION schema_information;

CREATE OR REPLACE FUNCTION public.schema_information(table_name text)
 RETURNS SETOF information_schema.columns
 LANGUAGE plpgsql
AS $function$
begin
    return query
    select *
    from information_schema.columns c
    where c.table_name = schema_information.table_name;
end;
$function$

DROP FUNCTION IF EXISTS table_exists;

DROP FUNCTION IF EXISTS create_table;

DROP FUNCTION IF EXISTS alter_table;

DROP FUNCTION IF EXISTS foreign_table;

DROP FUNCTION IF EXISTS table_schema;

DROP FUNCTION IF EXISTS schema_information;

GRANT
SELECT
    ON ALL TABLES IN SCHEMA public TO anon,
    public,
    authenticated;

create function schema_information(table_name text)
returns setof information_schema.columns
language plpgsql
as $$
begin
    return query
    select *
    from information_schema.columns c
    where c.table_name = schema_information.table_name;
end;
$$;

create function table_schema(table_name text)
returns jsonb as $$
declare
    schema jsonb;
begin
    select jsonb_agg(jsonb_build_object(
        'column_name', c.column_name,
        'data_type', c.data_type,
        'character_maximum_length', c.character_maximum_length,
        'is_nullable', c.is_nullable,
        'column_default', c.column_default
    )) into schema
    from information_schema.columns c
    where c.table_name = table_schema.table_name;
    
    return schema;
end;
$$ language plpgsql;

create function alter_table (query_text TEXT) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE query_text;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error executing query: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

create function foreign_table (query_text TEXT) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE query_text;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error executing query: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

create function create_table (query_text TEXT) RETURNS void AS $$
BEGIN
    BEGIN
        EXECUTE query_text;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'Error executing query: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

create function table_exists (name TEXT) RETURNS BOOLEAN AS $$
declare
    table_exists boolean;
begin
    select exists (
        select 1
        from information_schema.tables
        where table_name = name
    ) into table_exists;

    return table_exists;
end;
$$ LANGUAGE plpgsql;

DROP FUNCTION IF EXISTS reviews_pending;

DROP FUNCTION IF EXISTS search;

DROP FUNCTION IF EXISTS order_details;

DROP FUNCTION IF EXISTS booking;

DROP FUNCTION IF EXISTS blackout_dates;

DROP FUNCTION IF EXISTS reviews_update;

DROP FUNCTION IF EXISTS reviews_create;

DROP FUNCTION IF EXISTS tour_history;

DROP FUNCTION IF EXISTS tour_details;

DROP FUNCTION IF EXISTS favourites;

DROP FUNCTION IF EXISTS products;

DROP FUNCTION IF EXISTS discover;

DROP FUNCTION IF EXISTS products_details;

DROP FUNCTION IF EXISTS signed_in;

DROP FUNCTION IF EXISTS profile;

DROP FUNCTION IF EXISTS profile_update;

CREATE
OR REPLACE FUNCTION profile_update (DATA JSONB) RETURNS TABLE (
  Id INTEGER,
  NAME TEXT,
  Email TEXT,
  ProviderKey TEXT,
  ProviderDisplayName TEXT,
  LoginProvider TEXT,
  MobileNumber TEXT,
  PASSWORD TEXT,
  IsVerified BOOLEAN,
  ProfilePhotoUrl TEXT,
  UUID TEXT
) AS $$
DECLARE
    name TEXT;
    email TEXT;
    provider_key TEXT;
    provider_display_name TEXT;
    login_provider TEXT;
    mobile_number TEXT;
    password TEXT;
    is_verified BOOLEAN;
    profile_photo_url TEXT;
    uuid TEXT;
BEGIN
    -- Extract values from the JSON object
    name := data->>'Name';
    email := data->>'Email';
    provider_key := data->>'ProviderKey';
    provider_display_name := data->>'ProviderDisplayName';
    login_provider := data->>'LoginProvider';
    mobile_number := data->>'MobileNumber';
    password := data->>'Password';
    is_verified := (data->>'IsVerified')::BOOLEAN;
    profile_photo_url := data->>'ProfilePhotoUrl';
    uuid := data->>'Uuid';

    -- Update the user record with non-null and non-empty fields
    UPDATE "Users"
    SET
        "Name" = COALESCE(NULLIF(name, ''), "Name"),
        "Email" = COALESCE(NULLIF(email, ''), "Email"),
        "ProviderKey" = COALESCE(NULLIF(provider_key, ''), "ProviderKey"),
        "ProviderDisplayName" = COALESCE(NULLIF(provider_display_name, ''), "ProviderDisplayName"),
        "LoginProvider" = COALESCE(NULLIF(login_provider, ''), "LoginProvider"),
        "MobileNumber" = COALESCE(NULLIF(mobile_number, ''), "MobileNumber"),
        "Password" = COALESCE(NULLIF(password, ''), "Password"),
        "IsVerified" = COALESCE(is_verified, "IsVerified"),
        "ProfilePhotoUrl" = COALESCE(NULLIF(profile_photo_url, ''), "ProfilePhotoUrl")
    WHERE "Uuid" = uuid;

    -- Return the updated record
    RETURN QUERY
    SELECT
        "Id",
        "Name",
        "Email",
        "ProviderKey",
        "ProviderDisplayName",
        "LoginProvider",
        "MobileNumber",
        "Password",
        "IsVerified",
        "ProfilePhotoUrl",
        "Uuid"
    FROM "Users"
    WHERE "Uuid" = uuid;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION profile (user_id BIGINT) RETURNS JSON AS $$
DECLARE
    user_record JSON;
BEGIN
    SELECT to_json(u)
    INTO user_record
    FROM "Users" u
    WHERE "Id" = user_id;

    RETURN user_record;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION signed_in (DATA json) RETURNS "Users" AS $$
DECLARE
    user_id bigint;
    user_record "Users";
BEGIN
    -- Check if user exists
    SELECT "Id" INTO user_id FROM "Users" WHERE "Email" = data->>'email';
    
    -- If user does not exist, create a new user
    IF user_id IS NULL THEN
        INSERT INTO "Users" ("IsVerified", "Email", "ProviderKey", "ProviderDisplayName", "LoginProvider", "MobileNumber", "Password", "ProfilePhotoUrl", "Uuid", "Name")
        VALUES (
            (data->>'isVerified')::boolean,
            data->>'email',
            data->>'providerKey',
            data->>'providerDisplayName',
            data->>'loginProvider',
            data->>'mobileNumber',
            data->>'password',
            data->>'profilePhotoUrl',
            data->>'uuid',
            data->>'name'
        )
        RETURNING * INTO user_record;
    ELSE
        -- If user exists, update all information
        UPDATE "Users"
        SET "IsVerified" = (data->>'isVerified')::boolean,
            "ProviderKey" = data->>'providerKey',
            "ProviderDisplayName" = data->>'providerDisplayName',
            "LoginProvider" = data->>'loginProvider',
            "MobileNumber" = data->>'mobileNumber',
            "Password" = data->>'password',
            "ProfilePhotoUrl" = data->>'profilePhotoUrl',
            "Uuid" = data->>'uuid',
            "Name" = data->>'name'
        WHERE "Id" = user_id
        RETURNING * INTO user_record;
    END IF;
    
    -- Return the updated/inserted user row
    RETURN user_record;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION products () RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    -- Fetch all products data
    SELECT COALESCE(
        json_agg(json_build_object(
            'Id', p."Id",
            'Name', p."Name",
            'ShortDescription', p."ShortDescription",
            'LongDescription', p."LongDescription",
            'Rating', p."Rating",
            'Hours', p."Hours",
            'Locations', p."Locations",
            'Tags', p."Tags",
            'Status', p."Status",
            'Price', p."Price",
            'ThumbnailUrl', p."ThumbnailUrl",
            'StandardPrice', p."StandardPrice",
            'Type', p."Type",
            'Code', p."Code",
            'City', p."City",
            'Country', p."Country",
            'Region', p."Region",
            'StripePriceIdentifier', p."StripePriceIdentifier",
            'IsFeatured', p."IsFeatured",
            'FeatureOrder', p."FeatureOrder"
        )), '[]'::JSON)
    INTO result
    FROM public."Products" p where "IsFeatured"=true;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION discover () RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    -- Fetch all discover data
    SELECT COALESCE(
        json_agg(json_build_object(
            'Id', p."Id",
            'Name', p."Name",
            'ShortDescription', p."ShortDescription",
            'LongDescription', p."LongDescription",
            'Rating', p."Rating",
            'Hours', p."Hours",
            'Locations', p."Locations",
            'Tags', p."Tags",
            'Status', p."Status",
            'Price', p."Price",
            'ThumbnailUrl', p."ThumbnailUrl",
            'StandardPrice', p."StandardPrice",
            'Type', p."Type",
            'Code', p."Code",
            'City', p."City",
            'Country', p."Country",
            'Region', p."Region",
            'StripePriceIdentifier', p."StripePriceIdentifier",
            'IsFeatured', p."IsFeatured",
            'FeatureOrder', p."FeatureOrder"
        )), '[]'::JSON)
    INTO result
    FROM public."Products" p where "IsFeatured"=false;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION favourites (user_id INTEGER) RETURNS JSON AS $$
DECLARE
    fav_products JSON;
BEGIN
    SELECT json_agg(json_build_object(
        'Id', f."Id",
        'ProductId', f."ProductId",
        'UserId', f."UserId",
        'Status', f."Status",
        'Products', json_build_object(
            'Id', p."Id",
            'Name', p."Name",
            'ShortDescription', p."ShortDescription",
            'LongDescription', p."LongDescription",
            'Rating', p."Rating",
            'Hours', p."Hours",
            'Locations', p."Locations",
            'Tags', p."Tags",
            'Status', p."Status",
            'Price', p."Price",
            'ThumbnailUrl', p."ThumbnailUrl",
            'StandardPrice', p."StandardPrice",
            'Type', p."Type",
            'Code', p."Code",
            'City', p."City",
            'Country', p."Country",
            'Region', p."Region",
            'StripePriceIdentifier', p."StripePriceIdentifier",
            'IsFeatured', p."IsFeatured",
            'FeatureOrder', p."FeatureOrder"
        )
    )) INTO fav_products
    FROM public."Favourites" f
    JOIN public."Products" p ON f."ProductId" = p."Id"
    WHERE f."UserId" = user_id;

    RETURN fav_products;
END;
$$ LANGUAGE plpgsql;

-- tour_history
CREATE FUNCTION tour_history (user_id INTEGER) RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_agg(json_build_object(
        'orders', o,
        'products', p
    ))
    INTO result
    FROM public."Orders" o
    JOIN public."Products" p ON o."ProductId" = p."Id"
    WHERE o."UserId" = user_id;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION reviews_create (DATA jsonb) RETURNS jsonb AS $$
DECLARE
    review_id INTEGER;
    result jsonb;
BEGIN
    -- Insert ProductReviews and get review_id
    INSERT INTO "ProductReviews" ("ProductId", "UserId", "Rate", "Description", "DateTime", "Status", "Hospitality", "Impressiveness", "SeamlessExperience", "ValueForMoney")
    VALUES (
        COALESCE((data ->> 'ProductId')::INTEGER, 0),
        COALESCE((data ->> 'UserId')::INTEGER, 0),
        COALESCE((data ->> 'Rate')::INTEGER, 0),
        COALESCE(data ->> 'Description', 'No description'),
        COALESCE((data ->> 'DateTime')::TIMESTAMP WITH TIME ZONE, CURRENT_TIMESTAMP),
        COALESCE((data ->> 'Status')::INTEGER, 0),
        COALESCE((data ->> 'Hospitality')::NUMERIC, 1),
        COALESCE((data ->> 'Impressiveness')::NUMERIC, 1),
        COALESCE((data ->> 'SeamlessExperience')::NUMERIC, 1),
        COALESCE((data ->> 'ValueForMoney')::NUMERIC, 1)
    )
    RETURNING "Id" INTO review_id;

    -- Insert ProductReviewPhotos if any
    IF review_id IS NOT NULL AND jsonb_array_length(data -> 'Photos') > 0 THEN
        INSERT INTO "ProductReviewPhotos" ("ProductReviewId", "Url")
        SELECT review_id, photo_url::text
        FROM jsonb_array_elements_text(data -> 'Photos') AS photo_url;
    END IF;

    -- Construct JSON object combining ProductReviews and ProductReviewPhotos
    SELECT jsonb_build_object(
        'Id', pr."Id",
        'ProductId', pr."ProductId",
        'UserId', pr."UserId",
        'Rate', pr."Rate",
        'Description', pr."Description",
        'DateTime', pr."DateTime",
        'Status', pr."Status",
        'Hospitality', pr."Hospitality",
        'Impressiveness', pr."Impressiveness",
        'SeamlessExperience', pr."SeamlessExperience",
        'ValueForMoney', pr."ValueForMoney",
        'Photos', COALESCE(
            jsonb_agg(jsonb_build_object(
                'Id', ph."Id",
                'ProductReviewId', ph."ProductReviewId",
                'Url', ph."Url"
            ) ORDER BY ph."Id"), '[]'::jsonb)
    ) INTO result
    FROM "ProductReviews" pr
    LEFT JOIN "ProductReviewPhotos" ph ON pr."Id" = ph."ProductReviewId"
    WHERE pr."Id" = review_id
    GROUP BY pr."Id";

    -- Update Orders table IsReview to 2 if successful
    IF review_id IS NOT NULL THEN
        UPDATE "Orders"
        SET "IsReview" = 2
        WHERE "Id" = (data ->> 'OrderId')::INTEGER;
    END IF;

    RETURN COALESCE(result, '{}'::jsonb);
END;
$$ LANGUAGE plpgsql;

-- tour_details
CREATE
OR REPLACE FUNCTION tour_details (order_id BIGINT, user_id bigint) RETURNS JSONB AS $$
DECLARE 
  order_json JSONB; 
  product_json JSONB; 
  contacts_json JSONB; 
  guests_json JSONB; 
  itineraries_json JSONB; 
  reviews_json JSONB; 
  inclusions_json JSONB;
  additional_info_json JSONB;
BEGIN 
  -- Fetch order details 
  SELECT to_jsonb(o) INTO order_json 
  FROM public."Orders" o 
  WHERE o."Id" = order_id; 

  -- Ensure we have the order details before proceeding 
  IF order_json IS NULL THEN 
    RAISE EXCEPTION 'Order with ID % does not exist', order_id; 
  END IF; 

  -- Fetch product details associated with the order 
  SELECT to_jsonb(p) INTO product_json 
  FROM public."Products" p 
  WHERE p."Id" = (order_json->>'ProductId')::BIGINT; 

  -- Define contacts object 
  contacts_json := jsonb_build_object( 
    'whatsapp', '+61 412 345 678', 
    'instagram', '@tourlytours', 
    'twitter', '@tourlytours', 
    'wechat', '+61 412 345 678', 
    'viber', '+61 412 345 678', 
    'threads', '@tourlytours', 
    'line', '+61 412 345 678' 
  ); 

  -- Fetch guests associated with the order 
  SELECT jsonb_agg(to_jsonb(g)) INTO guests_json 
  FROM public."OrderGuests" g 
  WHERE g."OrderId" = order_id; 

  -- Fetch itineraries associated with the order 
  SELECT jsonb_agg(to_jsonb(i)) INTO itineraries_json 
  FROM public."ProductItineraries" i 
  WHERE i."ProductId" = (order_json->>'ProductId')::BIGINT; 

  -- Fetch product reviews with images associated with the order 
  SELECT to_jsonb( 
           jsonb_build_object( 
               'Id', pr."Id", 
               'ValueForMoney', pr."ValueForMoney", 
               'Rate', pr."Rate", 
               'DateTime', pr."DateTime", 
               'Hospitality', pr."Hospitality", 
               'Impressiveness', pr."Impressiveness", 
               'SeamlessExperience', pr."SeamlessExperience", 
               'Description', pr."Description", 
               'ProductReviewPhotos', COALESCE(jsonb_agg(to_jsonb(prp)), '[]'::jsonb)  -- Changed '{}'::json to '[]'::jsonb 
           ) 
       ) INTO reviews_json 
  FROM public."ProductReviews" pr 
  LEFT JOIN public."ProductReviewPhotos" prp ON pr."Id" = prp."ProductReviewId" 
  WHERE pr."ProductId" = (order_json->>'ProductId')::BIGINT AND pr."UserId" = user_id
  GROUP BY pr."Id"; 

  -- Fetch product inclusions associated with the product 
  SELECT jsonb_agg(to_jsonb(pi)) INTO inclusions_json 
  FROM public."ProductInclusion" pi 
  WHERE pi."ProductId" = (order_json->>'ProductId')::BIGINT; 

  -- Fetch additional information associated with the product 
  SELECT jsonb_agg(to_jsonb(ai)) INTO additional_info_json 
  FROM public."ProductAdditionalInformation" ai 
  WHERE ai."ProductId" = (order_json->>'ProductId')::BIGINT; 

  -- Return the final JSON structure 
  RETURN jsonb_build_object( 
    'orders', order_json, 
    'product', product_json, 
    'contacts', contacts_json, 
    'guests', COALESCE(guests_json, '[]'::jsonb), 
    'itineraries', COALESCE(itineraries_json, '[]'::jsonb), 
    'reviews', COALESCE(reviews_json, '{}'::jsonb), 
    'inclusions', COALESCE(inclusions_json, '[]'::jsonb),
    'additional', COALESCE(additional_info_json, '[]'::jsonb)
  ); 
END; 
$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION reviews_update (data jsonb) RETURNS jsonb AS $$
DECLARE
    review_id INTEGER;
    result jsonb;
BEGIN
    -- Update ProductReviews
    UPDATE "ProductReviews"
    SET
        "ProductId" = COALESCE((data ->> 'ProductId')::INTEGER, "ProductId"),
        "UserId" = COALESCE((data ->> 'UserId')::INTEGER, "UserId"),
        "Rate" = COALESCE((data ->> 'Rate')::INTEGER, "Rate"),
        "Description" = COALESCE(NULLIF(data ->> 'Description', ''), "Description"),
        "DateTime" = COALESCE((data ->> 'DateTime')::TIMESTAMP WITH TIME ZONE, "DateTime"),
        "Status" = COALESCE((data ->> 'Status')::INTEGER, "Status"),
        "Hospitality" = COALESCE((data ->> 'Hospitality')::NUMERIC, "Hospitality"),
        "Impressiveness" = COALESCE((data ->> 'Impressiveness')::NUMERIC, "Impressiveness"),
        "SeamlessExperience" = COALESCE((data ->> 'SeamlessExperience')::NUMERIC, "SeamlessExperience"),
        "ValueForMoney" = COALESCE((data ->> 'ValueForMoney')::NUMERIC, "ValueForMoney")
    WHERE "Id" = (data ->> 'Id')::INTEGER
    RETURNING "Id" INTO review_id;

    -- Remove specified photos
    DELETE FROM "ProductReviewPhotos"
    WHERE "Id" IN (
        SELECT (photo ->> 'Id')::INTEGER
        FROM jsonb_array_elements(data -> 'removePhotos') AS photo
    );

    -- Insert new photos if any
    IF review_id IS NOT NULL AND jsonb_array_length(data -> 'Photos') > 0 THEN
        INSERT INTO "ProductReviewPhotos" ("ProductReviewId", "Url")
        SELECT review_id, photo_url::text
        FROM jsonb_array_elements(data -> 'Photos') AS photo_url;
    END IF;

    -- Construct JSON object combining ProductReviews and ProductReviewPhotos
    SELECT jsonb_build_object(
        'id', pr."Id",
        'productId', pr."ProductId",
        'userId', pr."UserId",
        'rate', pr."Rate",
        'description', pr."Description",
        'dateTime', pr."DateTime",
        'status', pr."Status",
        'hospitality', pr."Hospitality",
        'impressiveness', pr."Impressiveness",
        'seamlessExperience', pr."SeamlessExperience",
        'valueForMoney', pr."ValueForMoney",
        'photos', COALESCE(
            jsonb_agg(jsonb_build_object(
                'id', ph."Id",
                'productReviewId', ph."ProductReviewId",
                'url', ph."Url"
            ) ORDER BY ph."Id"), '[]'::jsonb)
    ) INTO result
    FROM "ProductReviews" pr
    LEFT JOIN "ProductReviewPhotos" ph ON pr."Id" = ph."ProductReviewId"
    WHERE pr."Id" = review_id
    GROUP BY pr."Id";

    RETURN COALESCE(result, '{}'::jsonb);

END;
$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION blackout_dates (id integer) RETURNS SETOF "UnavailableProductDates" AS $$
DECLARE
    result_record "UnavailableProductDates"%rowtype;
BEGIN
    -- Selecting records
    FOR result_record IN
        SELECT *
        FROM "UnavailableProductDates"
        WHERE "ProductId" = id AND "Date" >= current_date
    LOOP
        -- Returning each record found
        RETURN NEXT result_record;
    END LOOP;

    -- End function
    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION booking (data jsonb) RETURNS SETOF "Orders" AS $$
DECLARE
    order_id bigint;
    guest_record jsonb;
    order_date timestamptz;
BEGIN
    -- Extract order_date
    order_date := (data->>'Date')::timestamptz;

    -- Insert order record
    INSERT INTO "Orders" (
        "ProductId", "UserId", "OrderNumber", "Date", "TotalNumberOfGuest",
        "Language", "PreferedDriverGender", "HotelName", "HotelAddress",
        "HotelRoomNumber", "ContactPersonName", "ContactPersonEmail",
        "ContactPersonMobile", "StripeToken", "StripeReferrenceNumber",
        "Status", "IsPaid", "TotalAmount", "CreatedAtDateTime", "UpdatedAtDateTime"
    )
    VALUES (
        (data->>'ProductId')::bigint,
        (data->>'UserId')::bigint,
        (data->>'OrderNumber')::text,
        order_date,
        (data->>'TotalNumberOfGuest')::bigint,
        (data->>'Language')::text,
        (data->>'PreferedDriverGender')::text,
        (data->>'HotelName')::text,
        (data->>'HotelAddress')::text,
        (data->>'HotelRoomNumber')::text,
        (data->>'ContactPersonName')::text,
        (data->>'ContactPersonEmail')::text,
        (data->>'ContactPersonMobile')::text,
        (data->>'StripeToken')::text,
        (data->>'StripeReferrenceNumber')::text,
        (data->>'Status')::TEXT,
        (data->>'IsPaid')::boolean,
        (data->>'TotalAmount')::numeric,
        CURRENT_TIMESTAMP, -- CreatedAtDateTime
        CURRENT_TIMESTAMP -- UpdatedAtDateTime
    )
    RETURNING "Id" INTO order_id;

    -- Insert guest users
    IF data->>'guests' IS NOT NULL THEN
        -- Cast data->'guests' to an array
        FOR guest_record IN SELECT jsonb_array_elements(data->'guests') LOOP
            INSERT INTO "OrderGuests" (
                "Name", "PassportNumber", "OrderId"
            )
            VALUES (
                (guest_record->>'Name')::text,
                (guest_record->>'PassportNumber')::text,
                order_id
            );
        END LOOP;
    END IF;

    -- Add data into UnavailableProductDates table
    INSERT INTO "UnavailableProductDates" (
        "ProductId", "Date", "Description"
    )
    VALUES (
        (data->>'ProductId')::bigint,
        order_date,
        'Unavailable due to booking'
    );

    -- Return the order details
    RETURN QUERY SELECT * FROM "Orders" WHERE "Id" = order_id;

END;
$$ LANGUAGE plpgsql;

create
or replace function order_details (order_number text) returns json as $$
DECLARE
    order_id bigint;
    product_id bigint;
    orders json;
    product json;
    guests json;
    itineraries json;
    contacts json;
    inclusions jsonb;
    additional_info jsonb;
BEGIN
    -- Get order_id and product_id based on OrderNumber
    SELECT "Id", "ProductId"
    INTO order_id, product_id
    FROM "Orders"
    WHERE "OrderNumber" = order_number;

    -- Get order details
    SELECT to_json("Orders")
    INTO orders
    FROM "Orders"
    WHERE "Id" = order_id;

    -- Get product details
    SELECT to_json("Products")
    INTO product
    FROM "Products"
    WHERE "Id" = product_id;

    -- Get all guest details for the order
    SELECT json_agg(row_to_json("OrderGuests"))
    INTO guests
    FROM "OrderGuests"
    WHERE "OrderId" = order_id;

    -- Get all product itineraries details
    SELECT json_agg(row_to_json("ProductItineraries"))
    INTO itineraries
    FROM "ProductItineraries"
    WHERE "ProductId" = product_id;

    -- Define social contacts details
    contacts := json_build_object(
        'whatsapp', '+61 412 345 678',
        'instagram', '@tourlytours',
        'twitter', '@tourlytours',
        'wechat', '+61 412 345 678',
        'viber', '+61 412 345 678',
        'threads', '@tourlytours',
        'line', '+61 412 345 678'
    );

    SELECT jsonb_agg(to_jsonb(pi)) INTO inclusions 
    FROM public."ProductInclusion" pi 
    WHERE pi."ProductId" = product_id; 

    -- Fetch additional information associated with the product 
    SELECT jsonb_agg(to_jsonb(ai)) INTO additional_info
    FROM public."ProductAdditionalInformation" ai 
    WHERE ai."ProductId" = product_id; 

    -- Combine order, product, guest details, itineraries, and contacts into a single JSON object
    RETURN json_build_object(
        'orders', orders,
        'product', product,
        'guests', guests,
        'itineraries', itineraries,
        'contacts', contacts,
        'inclusions', inclusions,
        'additional', additional_info
    );

END;
$$ language plpgsql;

CREATE
OR REPLACE FUNCTION search (k text, d text) RETURNS SETOF "Products" AS $$
DECLARE
    result_record "Products";
BEGIN
    FOR result_record IN
        SELECT p.*
        FROM "Products" p
        WHERE p."Name" ILIKE '%' || k || '%'
          AND p."Id" NOT IN (
              SELECT upd."ProductId"
              FROM "UnavailableProductDates" upd
              WHERE upd."Date" = CAST(d AS timestamp with time zone)
          )
    LOOP
        RETURN NEXT result_record;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

CREATE
OR REPLACE FUNCTION reviews_pending (data json) RETURNS jsonb AS $$
DECLARE
    id bigint;
    user_id bigint;
    order_detail jsonb;
BEGIN
    -- Extract the UserId from the input data
    id := (data->>'Id')::bigint;
    user_id := (data->>'UserId')::bigint;

    -- Prepare the SQL query dynamically based on whether id is NULL or not
    IF id IS NULL THEN
        SELECT json_build_object(
            'order', to_jsonb(o),
            'product', to_jsonb(p)
        ) INTO order_detail
        FROM "Orders" o
        JOIN "Products" p ON o."ProductId" = p."Id"
        WHERE o."UserId" = user_id
        AND o."Status" = 'COMPLETED'
        AND o."IsReview" = 0
        LIMIT 1;
    ELSE
        SELECT json_build_object(
            'order', to_jsonb(o),
            'product', to_jsonb(p)
        ) INTO order_detail
        FROM "Orders" o
        JOIN "Products" p ON o."ProductId" = p."Id"
        WHERE o."UserId" = user_id
        AND o."Id" = id
        LIMIT 1;
    END IF;

    -- Return the combined order and product detail in a JSON object
    IF order_detail IS NULL THEN
        RETURN NULL;
    ELSE
        RETURN order_detail;
    END IF;
END;
$$ LANGUAGE plpgsql;