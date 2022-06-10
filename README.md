# EXTRACT_SCHEMA.PSM@mysql

EXTRACT_SCHEMA.PSM@mysql is implementation of [EXTRACT_SCHEMA.PSM](https://github.com/telitas/EXTRACT_SCHEMA.PSM) in MySQL.

MySQL 8 or later is supported.

## Description

The following are MySQL-specific restrictions.

- Common
    - There are no equivalent types for `INTERVAL`.
    - `DATETIME` is considered to be similar to `TIMESTAMP WITHOUT TIME ZONE` in ISO/IEC 9075.
    - `TIMESTAMP` is considered to be similar to `TIMESTAMP WITH TIME ZONE` in ISO/IEC 9075.
- XML SChema
    - XML Schema is not supported. Because MySQL does not have XML function.
- JSON Schema
    - `TIME` type is translated to `string` with `pattern=^-?(?:83[0-8]|8[0-2][0-9]|[0-7]?[0-9]{1,2}):[0-5]?[0-9]:[0-5]?[0-9](?:.[0-9]{1,6})?$` restriction.
    - `TIMESTAMP` types is translated to `date-time` with `pattern=^(?!.*([+-][0-9]{2}:[0-9]{2})).*$` restriction.

## License

MIT

Copyright (c) 2022 telitas

See the LICENSE file or https://opensource.org/licenses/mit-license.php for details.
