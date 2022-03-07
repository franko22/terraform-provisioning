terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  features {}
}
# RG
resource "azurerm_resource_group" "rg" {
  name     = "RG_MyAPP_DemoTFCLOUD"
  location = "West Europe"

}
# Use Web App module
module "webapp" {
  source               = "app.terraform.io/demoBook/webapp/azurerm"
  version              = "1.0.4"
  service_plan_name    = "demoappsp"
  app_name             = "myappdemobookcloud"
  location             = "West Europe"
  resource_group_name = azurerm_resource_group.rg.name
  sp_sku               = "Standard" #"Standard"
  ftps_state           = "FtpsOnly"
}


### USING CLI #######
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "demoBook"

    workspaces {
      name = "demo-app-remote"
    }
  }
}
