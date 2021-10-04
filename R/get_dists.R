#' Get subnational nutrient intake distributions
#'
#' This function retrieves the subnational nutrient intake distributions modelled by Passarreli et al. (in prep).
#'
#' @param nutrients A character vector of nutrients of interest (e.g., "Iron", "Calcium", etc.)
#' @param isos A character vector of ISO3s of countries of interest (e.g., "USA")
#' @param sexes A character string of sexes of interest (i.e., "M", "F", or "MF")
#' @param ages  A numeric vector of ages of interest (e.g., 10:50, 0:75, 55:90)
#' @return A data frame with the parameters describing the requested subnational intake distributions
#' @examples
#' dists_all <- get_dists()
#' dists_usa <- get_dists(isos="USA")
#' dists_usa_iron <- get_dists(isos="USA", nutrients="Iron", sexes="MF")
#' dists_usa_iron_2040 <- get_dists(isos="USA", nutrients="Iron", sexes="MF", ages=20:40)
#' @export
get_dists <- function(nutrients=NULL, isos=NULL, sexes=NULL, ages=NULL) {

  # Nutrients
  nutrient_vals <- sort(unique(dists_full$nutrient))
  if(is.null(nutrients)){
    nutrients_do <- nutrient_vals
  }else{
    # For testing: nutrients <- "Iron"; nutrients <- c("Iron", "Plutonium")
    nutrient_check <- nutrients[!nutrients %in% nutrient_vals]
    if(length(nutrient_check)){stop("The following nutrients are not included in the data: ", paste(nutrient_check, collapse=", "))}
    nutrients_do <- nutrients
  }

  # Countries (ISOs)
  iso_vals <- sort(unique(dists_full$iso3))
  if(is.null(isos)){
    isos_do <- iso_vals
  }else{
    # For testing: isos <- "USA"; isos <- c("USA", "United States")
    iso_check <- isos[!isos %in% iso_vals]
    if(length(iso_check)){stop("The following ISO3s are not included in the data: ", paste(iso_check, collapse=", "))}
    isos_do <- isos
  }

  # Sexes
  # For testing: sexes <- "M"; sexes <- "males"
  if(is.null(sexes)){
    sexes_do <- c("Females", "Males")
  }else{
    sex_vals <- c("M", "F", "MF")
    sex_check <- sexes %in% sex_vals
    if(!sex_check){stop("The following sex code must be changed to either 'M', 'F', or 'MF': ", sexes)}
    if(sexes=="M"){sexes_do <- "Males"}
    if(sexes=="F"){sexes_do <- "Females"}
    if(sexes=="MF"){sexes_do <- c("Females", "Males")}
  }


  # Extract age groups
  age_group_vals <- paste(seq(0,95,5), seq(5,100,5)-1, sep="-")
  if(is.null(ages)){
    ages_groups_do <- age_group_vals
  }else{
    ages_groups_do <- cut(ages, breaks=seq(0,100,5), labels= age_group_vals) %>% unique() %>% as.character()
  }

  # Extract distributions of interest
  dists_use <- dists_full %>%
    # Filter data
    filter(nutrient %in% nutrients_do & iso3 %in% isos_do & sex %in% sexes_do & age_group %in% ages_groups_do) %>%
    filter(best_dist!="none")

  # Return
  return(dists_use)

}
