#Annotated R script
messy_spotify <- read.table("Spotify_datasets_2024/Spotify_Messy_210463749.txt", 
                            sep = '\t',    
                            header = T)   
# Read in data using read.table function
# sep = '\t' indicates that the file is tab-separated
# header = T Indicates that the file has a header row

install.packages("tidyr")
library(tidyr)
install.packages("dplyr")
library(dplyr)
# Installed packages 'tidyr' and 'dplyr' and loaded required libraries, enabling access to its functions

messy_spotify <- messy_spotify %>%
  mutate(track_artist = gsub("Bad Sunny", "Bad Bunny", track_artist))
# Fixed spelling in track_artist column from 'Bad Sunny' to 'Bad Bunny'
# %>% chains operations together making the code more tidy
# Used 'mutate' to modify the 'track_artist column' and change it in-place
# Used 'gsub' to replace occurrences of "Bad Sunny" with "Bad Bunny" in 'track_artist'

messy_spotify <- messy_spotify %>%
  rename(track_name = TTrack_nameff5)
# Renamed column from 'TTrack_nameff5' to 'track_name' using 'rename' function

str(messy_spotify,vec.len=2)
# Used 'str' function to display the structure of the dataset
# 'vec.len = 2' parameter sets the maximum length of vectors to be displayed to 2 to keep the output concise.

messy_spotify <- messy_spotify %>%
  mutate(mode = as.numeric(gsub("T", "", mode)))
# Removed 'T' from the mode column and converted each value to a numeric value
# Used 'mutate' to modify the 'mode' column and change it in-place
# Used 'as.numeric' to convert the 'mode' values to numeric format
# Used 'gsub' to replaces all occurrences of 'T' with an empty string in the 'mode' column

messy_spotify <- messy_spotify %>%
  mutate(
    key = as.numeric(key),
    track_popularity = as.numeric(track_popularity))
# Used 'mutate' to modify the 'key' and 'track_popularity' column 
# Used 'as.numeric' function to convert the specified columns to numeric format

messy_spotify <- messy_spotify %>%
  separate_wider_delim("danceability.energy", "_", names = c("danceability", "energy"))
# Used 'separate_wider_delim' function to separate 'danceability.energy' column into 2 columns 
# '_' denotes the delimiter used for separation
# names = c("danceability", "energy") defines the names for the two new columns 

messy_spotify <- messy_spotify %>%
  pivot_longer(cols = c(pop, rap, rock, r.b, edm),   
               names_to = "playlist_genre",    
               values_to = "playlist_subgenre",  
               values_drop_na = TRUE)   
# Used pivot_longer function to convert specified columns to a long format
# 'cols =' specifies columns to pivot
# The 'names_to' parameter designates the new column (playlist_genre) that will contain the genre names
# The values_to parameter indicates the new column (playlist_subgenre) that will store the subgenre values
# The values_drop_na parameter is set to TRUE to drop rows with missing values

messy_spotify <- messy_spotify %>%
  mutate(track_album_release_date = gsub('^75-', '1975-', track_album_release_date))
# Used 'mutate' to modify the 'track_album_release_date' column and change it in-place
# Used 'gsub' to replace occurrences of '75-' with '1975-' in the 'track_album_release_date' column using '^' as an anchor for the start of the string

messy_spotify <- messy_spotify %>%
  mutate(spotify_id = as.character(track_id)) %>%
  select(-c(track_id, playlist_id, track_album_id))
# Created a new column "spotify_id" using 'mutate' function
# Used 'as.character' to convert 'track_id' values to character format
# Used 'select (-c)' function to select and remove specified columns from the dataset

messy_spotify <- messy_spotify %>%
  select(spotify_id, 1:6, playlist_name, playlist_genre, playlist_subgenre, everything())
# Used 'select' function to select columns in the desired order
# The everything() function included all remaining columns

#OUTPUT DATA FILE
write.table(messy_spotify, "clean_spotify_210463749.txt",
            sep="\t",
            col.names = T,
            row.names = F,
            quote = F)

#Read the written file back to check output
clean_spotify_check <- read.table("clean_spotify_210463749.txt", sep = "\t", header = TRUE)







