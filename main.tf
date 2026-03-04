resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_data_factory_pipeline" "demo_pipeline" {
  name            = "demo-pipeline"
  data_factory_id = azurerm_data_factory.adf.id

  activities_json = <<JSON
[
  {
    "name": "WaitActivity",
    "type": "Wait",
    "typeProperties": {
      "waitTimeInSeconds": 15
    }
  }
]
JSON
}

resource "azurerm_data_factory_trigger_schedule" "demo_trigger" {
  name            = "demo-trigger"
  data_factory_id = azurerm_data_factory.adf.id

  pipeline_name = azurerm_data_factory_pipeline.demo_pipeline.name

  frequency = "Minute"
  interval  = 5

  start_time = "2025-01-01T00:00:00Z"
  activated  = true
}
