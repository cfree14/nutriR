

#' Dietary Reference Intake (DRI) values
#'
#' Dietary Reference Intake (DRIs) values from the Food and Nutrition Board of the National Academy of Sciences. The file includes DRIs for 42 nutrients and 22 life stage groups. The following DRI types are included in this dataset: Estimated Average Requirements (EARs), Adequate Intakes (AIs), Recommended Daily Averages (RDAs), and Upper Limits (ULs).
#'
#' @format A data frame with the following attributes::
#' \describe{
#'   \item{nutrient_type}{Type of nutrient (i.e., macronutrient, vitamin, element)}
#'   \item{nutrient_units}{Nutrient name and units}
#'   \item{nutrient}{Nutrient name}
#'   \item{units}{Nutrient units (e.g., g/d, mg/d, µg/d)}
#'   \item{sex_stage}{Sex and life stage (e.g., Infants, Women, Women (pregnant), Women (lactating))}
#'   \item{sex}{Sex (i.e., males, females, both)}
#'   \item{stage}{Life stage (i.e., infants, children, pregnancy, lactation, none)}
#'   \item{age_range}{Age range}
#'   \item{dri_type}{Dietary reference intake type (i.e., EAR, AI, RDA, UL)}
#'   \item{value}{DRI value}
#'   \item{footnote}{Footnote}
#' }
#' @source Food and Nutrition Board, National Academy of Sciences, Institute of Medicine (2020). Dietary Reference intakes: Estimated Average requirements and recommended intakes. Accessed at https://www.nal.usda.gov/sites/default/files/fnic_uploads//recommended_intakes_individuals.pdf.
"dris"
