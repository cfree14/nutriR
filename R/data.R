

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

#' EFSA Dietary Reference Values (DRVs)
#'
#' Dietary Reference Values (DRVs) from the European Food Safety Authority (EFSA).
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
"drvs"

#' Nutrient Reference Values (NRVs)
#'
#' This dataset provides the Nutrient Reference Values (NRVs) from Allen et al. (2020). Allen et al. (2020) selects values from the EFSA (European Food Safety Authority) and the Institute of Medicine (IOM) for average requirements (ARs) and upper levels of intake (ULs).
#'
#' @format A data frame with the following attributes::
#' \describe{
#'   \item{nutrient}{Nutrient name}
#'   \item{units}{Nutrient units (e.g., g/d, mg/d, µg/d)}
#'   \item{source}{Source (i.e., EFSA, IOM)}
#'   \item{sex}{Sex (i.e., males, females, both)}
#'   \item{stage}{Life stage (i.e., infants, children, pregnancy, lactation, none)}
#'   \item{age_group}{Age range}
#'   \item{nrv_type}{Nutrient reference value type (i.e., AR, UL)}
#'   \item{nrv}{DRI value}
#'   \item{nrv_note}{A note}
#' }
#' @source Allen, L.H., Carriquiry, A.L., Murphy, S.P. (2020) Perspective: proposed harmonized nutrient reference values for populations. Advances in Nutrition 11(3): 469-483.
"nrvs"

#' Subnational habitual nutrient intake distributions
#'
#' This dataset contains the subnational habitual nutrient intake distributions estimated by Passarelli et al. (in prep).
#'
#' @format A data frame with the following attributes::
#' \describe{
#'   \item{continent}{Continent}
#'   \item{country}{Country name}
#'   \item{iso3}{ISO3 code for country}
#'   \item{hdi_category}{Human Development Index (HDI) category}
#'   \item{hdi}{Human Development Index (HDI) category}
#'   \item{iron_type}{Iron bioavailability}
#'   \item{zinc_type}{Zin bioavailability}
#'   \item{nutrient_type}{Type of nutrient (i.e., macronutrient, vitamin, element)}
#'   \item{nutrient}{Nutrient name}
#'   \item{nutrient_units}{Nutrient name and units}
#'   \item{sex}{Sex (i.e., males, females, both)}
#'   \item{age_group}{Age group (5-yr intervals)}
#'   \item{sex_ear}{Sex used to assign EAR value}
#'   \item{age_group_ear}{Age group used to assign EAR value}
#'   \item{ear_units}{EAR units}
#'   \item{ear_cv}{Recommended coefficient of variation (CV) for the EAR value}
#'   \item{ear}{EAR value}
#'   \item{sex_ar}{Sex used to assign AR value}
#'   \item{age_group_ar}{Age group used to assign AR value}
#'   \item{ear_units}{AR units}
#'   \item{ar}{AR value}
#'   \item{g_shape}{Shape parameter for a gamma-distributed intake distribution}
#'   \item{g_rate}{Rate parameter for a gamma-distributed intake distribution}
#'   \item{g_ks}{K-S goodness-of-fit for a gamma-distributed intake distribution}
#'   \item{g_mu}{Mean of a gamma-distributed intake distribution}
#'   \item{g_cv}{Coefficient of variation (CV) of a gamma-distributed intake distribution}
#'   \item{g_var}{Variance a gamma-distributed intake distribution}
#'   \item{g_skew}{Skewness of a gamma-distributed intake distribution}
#'   \item{g_kurt}{Kurtosis of a gamma-distributed intake distribution}
#'   \item{g_sev_ear}{Summary exposure value (SEV) of a gamma-distributed intake distribution using EAR}
#'   \item{g_sev_ar}{Summary exposure value (SEV) of a gamma-distributed intake distribution using AR}
#'   \item{g_above_ul}{Proportion of population above the upper limit with the gamma distribution}
#'   \item{ln_meanlog}{Meanlog parameter for a lognormally-distributed intake distribution}
#'   \item{ln_sdlog}{Sdlog parameter for a lognormally-distributed intake distribution}
#'   \item{ln_ks}{K-S goodness-of-fit for a lognormally-distributed intake distribution}
#'   \item{ln_mu}{Mean of a lognormally-distributed intake distribution}
#'   \item{ln_cv}{Coefficient of variation (CV) of a lognormally-distributed intake distribution}
#'   \item{ln_var}{Variance a lognormally-distributed intake distribution}
#'   \item{ln_skew}{Skewness of a lognormally-distributed intake distribution}
#'   \item{ln_kurt}{Kurtosis of a lognormally-distributed intake distribution}
#'   \item{ln_sev_ear}{Summary exposure value (SEV) of a lognormally-distributed intake distribution using EAR}
#'   \item{ln_sev_ar}{Summary exposure value (SEV) of a lognormally-distributed intake distribution using AR}
#'   \item{ln_above_ul}{Proportion of population above the upper limit with the lognormal distribution}
#'   \item{best_dist}{Best distribution based on the K-S goodness-of-fit statistic}
#'   \item{mu}{Mean of the best intake distribution}
#'   \item{cv}{Coefficient of variation (CV) of the best intake distribution}
#'   \item{var}{Variance the best intake distribution}
#'   \item{skew}{Skewness of the best intake distribution}
#'   \item{kurt}{Kurtosis of the best intake distribution}
#'   \item{above_ul}{Proportion of population above the upper limit}
#'   \item{sev_ear}{Summary exposure value (SEV) of the best intake distribution using EAR}
#'   \item{sev_ar}{Summary exposure value (SEV) of the best intake distribution using AR}
#'   \item{ear_use}{EAR or AR}
#'   \item{sev}{Summary exposure value (SEV) of the best intake distribution using EAR}
#'   \item{cutpoint_sev_ear}{SEV calculated using cutpoint method and EAR}
#'   \item{cutpoint_sev_ar}{SEV calculated using cutpoint method and AR}
#'   \item{cutpoint_sev}{SEV calculated using cutpoint method}
#' }
#' @source Passarelli S, Free CM, Shepon A, Lee C, Moursi M, Cao L, Li Y, Crispim S, Schmidhuber J, Bromage S, Beal T, Golden CD (in prep) Global modeling of subnational habitual nutrient intake distributions. Near submission.
"dists_full"
