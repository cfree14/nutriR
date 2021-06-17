#' Plot subnational nutrient intake distributions
#'
#' This function prepares a quick plot comparing subnational nutrient intake distributions. It is provided a dataframe generated from the get_dists() function.
#'
#' @param dists A data frame of nutrient distributions
#' @return A plot
#' @examples
#' # A one nutrient example
#' dists_usa_iron <- get_dists(isos="USA", nutrients="Iron")
#' plot_dists(dists_usa_iron)
#'
#' # A two nutrient example
#' dists_usa_iron_vitB <- get_dists(isos="USA", nutrients=c("Iron", "Vitamin B12"))
#' plot_dists(dists_usa_iron_vitB)
#'
#' # A two nutrient-two country example
#' dists_usa_bgd_iron_vitB <- get_dists(isos=c("USA", "BGD"), nutrients=c("Iron", "Vitamin B12"))
#' plot_dists(dists_usa_bgd_iron_vitB)
#'
#' A whole countries data
#' dists_bfa <- get_dists(isos=c("BFA"))
#' plot_dists(dists_bfa)
#' @export
plot_dists <- function(dists){

  # Generate distributions
  dist_data <- generate_dists(dists) %>%
    mutate(age_group_lo = gsub("\\-.*", "", age_group) %>% as.numeric(),
           group=paste(sex, age_group_lo, sep="-"))

  # Plotting parameters
  n_sex <- n_distinct(dists$sex)
  n_age <- n_distinct(dists$age_group)
  n_country <- n_distinct(dists$country)
  n_nutrient <- n_distinct(dists$nutrient)

  # Theme
  base_theme <- theme(# Gridlines
                      panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(),
                      panel.background = element_blank(),
                      axis.line = element_line(colour = "black"))

  # One nutrient
  if(n_nutrient==1){

    # Nutrient
    nutrient_do <- unique(dists$nutrient)

    # Plot data
    g <- ggplot(dist_data, mapping=aes(x=intake, y=density, linetype=sex, color=age_group_lo, group=group)) +
      # Facet
      facet_wrap(~country) +
      # Lines
      geom_line() +
      # Labels
      labs(x="Daily habitual intake", y="Density", title=nutrient_do) +
      # Legend
      scale_linetype_discrete(name="Sex") +
      scale_color_gradientn(name="Age group", colors=RColorBrewer::brewer.pal(9, "YlOrRd")[4:9]) +
      guides(color = guide_colorbar(ticks.colour = "black", frame.colour = "black")) +
      # Theme
      theme_bw() + base_theme
    g

  # More nutrients
  }else{

    # Many countries
    if(n_country>1){

      # Plot data
      g <- ggplot(dist_data, mapping=aes(x=intake, y=density, linetype=sex, color=age_group_lo, group=group)) +
        # Facet
        facet_grid(nutrient~country, scales="free") +
        # Lines
        geom_line() +
        # Labels
        labs(x="Daily habitual intake", y="Density") +
        # Legend
        scale_linetype_discrete(name="Sex") +
        scale_color_gradientn(name="Age group", colors=RColorBrewer::brewer.pal(9, "YlOrRd")[4:9]) +
        guides(color = guide_colorbar(ticks.colour = "black", frame.colour = "black")) +
        # Theme
        theme_bw() + base_theme
      g

    }else{

      # Plot data
      g <- ggplot(dist_data, mapping=aes(x=intake, y=density, linetype=sex, color=age_group_lo, group=group)) +
        # Facet
        facet_wrap(~nutrient, scales="free") +
        # Lines
        geom_line() +
        # Labels
        labs(x="Daily habitual intake", y="Density") +
        # Legend
        scale_linetype_discrete(name="Sex") +
        scale_color_gradientn(name="Age group", colors=RColorBrewer::brewer.pal(9, "YlOrRd")[4:9]) +
        guides(color = guide_colorbar(ticks.colour = "black", frame.colour = "black")) +
        # Theme
        theme_bw() + base_theme
      g

    }

  }

  # Return
  return(g)

}
