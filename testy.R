library(xml2)
library(dplyr)

bjcp_beer_list <- read_xml("https://raw.githubusercontent.com/meanphil/bjcp-guidelines-2015/master/styleguide.xml")

kategorie <- bjcp_beer_list %>% xml_find_all("//styleguide/class") %>% xml_attr("type")

print(kategorie)

wyb_1 <- kategorie[1]
kod_xml <- paste0("//styleguide/class[@type= '",wyb_1,"']/category/name")
kod_xml2 <- paste0("//styleguide/class[@type= '",wyb_1,"']/category")

grupy <- bjcp_beer_list %>% xml_find_all(kod_xml) %>% xml_text()
grupy_id <- bjcp_beer_list %>% xml_find_all(kod_xml2) %>% xml_attr("id")

print(grupy)

wyb_2 <- grupy_id[2]
kod_xml3 <- paste0("//styleguide/class[@type= '",wyb_1,"']/category[@id = '",wyb_2,"']/subcategory/name")
kod_xml4 <- paste0("//styleguide/class[@type= '",wyb_1,"']/category[@id = '",wyb_2,"']/subcategory")

podgrupy <- bjcp_beer_list %>% xml_find_all(kod_xml3) %>% xml_text()

podgrupy_id <- bjcp_beer_list %>% xml_find_all(kod_xml4) %>% xml_attr("id")

wyb_3 <- podgrupy_id[3]

kod_xml5 <- paste0("//styleguide/class[@type= '",wyb_1,"']/category[@id = '",wyb_2,"']/subcategory[@id = '",wyb_3,"']")

info_styl <- bjcp_beer_list %>% xml_find_all(kod_xml5) %>% as_list()

info_styl[[1]]$name[[1]]
info_styl[[1]]$flavor[[1]]
info_styl[[1]]$appearance[[1]]
info_styl[[1]]$mouthfeel[[1]]
info_styl[[1]]$impression[[1]]
info_styl[[1]]$examples[[1]]
info_styl[[1]]$entry_instructions[[1]]
info_styl[[1]]$stats[[1]]


library(deeplr)

translate2(info_styl[[1]]$mouthfeel[[1]], target_lang = "PL", source_lang = "EN", auth_key = "bb9dbc3c-1340-898d-24bb-ddf617876a18:fx")

tl_polski(info_styl[[1]]$flavor[[1]])
