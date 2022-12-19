## Usage

```sh
# Build app

make build

# Up app

make up
```

url: http://localhost:4000/

## Test User

Email: test@test.ru
Password: password

## Postman collections

`./postman_collection.json`

The test user data is stored in collection variables. You can immediately call Session/init.

All dependencies are already created for the test user.

#### Attention!
---
Creating any entity will overwrite that entity's data in the collection.
After creating a new user, the next Session/init will be on behalf of the new user.