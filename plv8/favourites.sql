drop function if exists favourites;

create function favourites (header json, body json) returns json as $$
  try {
    var id = header.id;
    var uuid = header.uuid;

    if (id == null || id <= 0 || id == '') {
      return null;
    }

    var result = plv8.execute('SELECT p.* FROM "Favourites" f join JOIN "Products" p ON f."ProductId" = p."ProductId" WHERE f."UserId" = $1', [id]);
    return result[0];
  } catch (e) {
    plv8.elog(NOTICE, e.message);
    return e.message;
  }

$$ language plv8;

select favourites (
        '{"id": 19, "uuid": "96251ab3-dcdb-4870-bc22-4cf1a509974f"}', '{}'
    );