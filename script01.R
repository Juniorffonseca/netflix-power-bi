########################
## Carregando pacotes ##
########################

library(dplyr)
library(tidyr)
library(rvest)
library(quantmod)
library(httr)
library(tibble)

###################
## Base de dados ##
###################


## Ler arquivo CSV ##
df1 <- read.csv("netflix_titles.csv", header = T, sep = ',', encoding = "UTF-8")

## Dividir a coluna de duração em duas: uma para o número e o outro o tipo de duração ##
ds_netflix_titles <- df1 %>% 
  separate(duration, into = c("duration_num", "duration_type"), sep = " ") %>% 
  separate_rows(cast, sep = ", ")

## Exportar arquivo ##
write.csv2(ds_netflix_titles, "ds_netflix_titles.csv", sep = ';')


##########################
## Wikipedia html Table ##
##########################

## URL Wikipedia ##
oscar_url <- "https://en.wikipedia.org/wiki/List_of_Academy_Award-winning_films"

## Pegando Oscar's table ##
ds_oscars <- read_html(oscar_url) %>% 
  html_node("table") %>% 
  html_table() %>% 
  select(title = Film, Awards)

write.csv2(ds_oscars, "ds_oscars.csv", sep = ";")


####################
## Avaliação IMDB ##
####################

## URL IMDB ##

imdb_url <- "https://www.imdb.com/chart/top/"

## Pegando os nomes dos títulos em inglês ##
ds_imdb_title <- imdb_url %>% 
  session(add_headers("Accept-Language" = "en")) %>% 
  read_html() %>% 
  html_nodes(".titleColumn a") %>% 
  html_text()

## Pegando a avaliação Imdb ##
ds_imdb_rating <- read_html(imdb_url) %>% 
  html_nodes(".imdbRating strong") %>% 
  html_text()

## Criando tabela Imdb ##
ds_imdb <- as_tibble(cbind(rating = ds_imdb_rating,title = ds_imdb_title)) 

