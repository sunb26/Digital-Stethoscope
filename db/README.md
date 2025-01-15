## How to update the schema

### Install Atlasgo
#### https://atlasgo.io/getting-started/ 


#### 1. atlas schema inspect -u "\<INSERT DB CONNECTION STRING>" > schema.hcl

#### 2. atlas schema apply -u "\<INSERT DB CONNECTION STRING>" --to file://schema.hcl