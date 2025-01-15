table "patient" {
  schema = schema.public
  comment = "This table contains all attributes that represent a patient."
  column "physician_id" {
    null = false
    type = integer
  }
  column "patient_id" {
    null = false
    type = serial
  }
  column "firstname" {
    null = false
    type = text
  }
  column "lastname" {
    null = false
    type = text
  }
  column "email" {
    null = true
    type = text
  }
  primary_key {
    columns = [column.patient_id]
  }
  foreign_key "physician_id" {
    columns     = [column.physician_id]
    ref_columns = [table.physician.column.physician_id]
    on_update   = NO_ACTION
    on_delete   = NO_ACTION
    comment = "No action will be taken if the physician is removed from the database in order to preserve patient records."
  }
}

table "physician" {
  schema = schema.public
  comment = "This table contains all attributes that represent a physician."
  column "physician_id" {
    null = false
    type = serial
  }
  column "email" {
    null = false
    type = text
  }
  primary_key {
    columns = [column.physician_id]
  }
}

table "app_login"{
  schema = schema.public
  comment = "This table contains the login credentials of each patient for the phone app."
  column "patient_id" {
    null = false
    type = integer
  }
  column "username" {
    null = false
    type = text
  }
  column "password" {
    null = false
    type = text
  }
  primary_key {
    columns = [column.patient_id]
  }
  foreign_key "patient_id" {
    columns     = [column.patient_id]
    ref_columns = [table.patient.column.patient_id]
    on_update   = CASCADE
    on_delete   = CASCADE
  }
}

schema "public" {
  comment = "standard public schema"
}
