DROP FUNCTION blackout_dates;
DROP FUNCTION booking;
DROP FUNCTION order_details;
DROP FUNCTION search;

CREATE FUNCTION public.booking(data json)
RETURNS SETOF "Orders"
LANGUAGE plpgsql
AS $function$
DECLARE
order_id bigint;
guest_record json;
order_date timestamptz;
date_of_birth timestamptz;
BEGIN
-- Extract order_date
order_date := data->>'Date';

    -- Insert order record
    INSERT INTO "Orders" ("ProductId", "UserId", "OrderNumber", "Date", "TotalNumberOfGuest", "Language", "PreferedDriverGender", "HotelName", "HotelAddress", "HotelRoomNumber", "ContactPersonName", "ContactPersonEmail", "ContactPersonMobile", "StripeToken", "StripeReferrenceNumber", "Status", "IsPaid", "TotalAmount", "CreatedAtDateTime", "UpdatedAtDateTime")
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
        (DATA ->> 'TotalAmount')::numeric,
        CURRENT_TIMESTAMP, -- CreatedAtDateTime,
        CURRENT_TIMESTAMP -- UpdatedAtDateTime
    )
    RETURNING "Id" INTO order_id;

    -- Insert guest users
    IF data->>'guests' IS NOT NULL THEN
        -- Cast data->'guests' to an array
        FOR guest_record IN SELECT json_array_elements(data->'guests') LOOP
            date_of_birth := guest_record->>'DateOfBirth';
            INSERT INTO "OrderGuests" (
                "Name", "DateOfBirth", "PassportNumber", "OrderId"
            )
            VALUES (
                (guest_record->>'Name')::text,
                date_of_birth,
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

    -- Return the order_id
    return query select * from "Orders" where "Id" = order_id;

END;
$function$

CREATE FUNCTION public.order_details(order_number text)
RETURNS json
LANGUAGE plpgsql
AS $function$
DECLARE
order_id bigint;
product_id bigint;
orders json;
product json;
guests json;
itineraries json;
contacts json;
BEGIN
-- Get order_id based on OrderNumber
SELECT "Id", "ProductId" INTO order_id, product_id FROM "Orders" WHERE "OrderNumber" = order_number;

    -- Get order details
    SELECT to_json("Orders") INTO orders FROM "Orders" WHERE "Id" = order_id;

    -- Get product details
    SELECT to_json("Products") INTO product FROM "Products" WHERE "Id" = product_id;

    -- Get all guest details for the order
    SELECT json_agg(row_to_json("OrderGuests")) INTO guests FROM "OrderGuests" WHERE "OrderId" = order_id;

    -- Get all guest details for the order
    SELECT json_agg(row_to_json("ProductItineraries")) INTO itineraries FROM "ProductItineraries" WHERE "ProductId" = product_id;

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


    -- Combine order, product, and guest details into a single JSON object
    RETURN json_build_object(
        'orders', orders,
        'product', product,
        'guests', guests,
        'itineraries', itineraries,
        'contacts', contacts
    );

END;
$function$

CREATE FUNCTION public.search(k text, d text)
RETURNS SETOF "Products"
LANGUAGE sql
AS $function$
SELECT
p.\*
FROM
"Products" p
WHERE
p."Name" ILIKE '%' || k || '%'
AND p."Id" NOT IN (
SELECT
upd."ProductId"
FROM
"UnavailableProductDates" upd
WHERE
upd."Date" = CAST(d AS timestamp with time zone)
);
$function$

$$
$$
