library(dplyr)
library(ggplot2)
shootings_data <- read.csv("data/police_killings.csv", stringsAsFactors = FALSE)

#PERCENT DEATHS OF A CHOSEN RACE, PER STATE
victim_race <- shootings_data %>% 
  filter(raceethnicity == "Black") %>% 
  group_by(state) %>% 
  count()
names(victim_race)[2] <- "num_race_victims"
deaths_by_state <- shootings_data %>% 
  group_by(state) %>% 
  count()
names(deaths_by_state)[2] <- "num_state_deaths"

deaths_race_and_state <- left_join(victim_race, deaths_by_state)
deaths_race_and_state <- deaths_race_and_state %>% 
  mutate(percent_race_deaths = num_race_victims / num_state_deaths * 100)

#SHARE POPULATION BY STATE)
state_share_race <- shootings_data %>%
  group_by(state) %>% 
  summarise(
    mean_pop_share = mean(as.numeric(share_black), na.rm = TRUE),
    mean_pov = mean(as.numeric(pov), na.rm = TRUE)
            )

#COMBINE THE TWO FINAL TABLES
chosen_data <- left_join(deaths_race_and_state, state_share_race)
plot <- ggplot(data = chosen_data, mapping = aes(x = percent_race_deaths,
                                                 y = mean_pop_share,
                                                 color = mean_pov, size = 10,
                                                 alpha = .3)) +
  geom_point() +
  scale_color_gradient(low = "blue", high = "red")
plot
