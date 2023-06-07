#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(xml2)
library(dplyr)
library(deeplr)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  
  rv <- reactiveValues()
  
  rv$bjcp_beer_list <- read_xml("https://raw.githubusercontent.com/meanphil/bjcp-guidelines-2015/master/styleguide.xml")

  
               
  observeEvent(input$kategoria,{
    rv$kod_xml <- paste0("//styleguide/class[@type= '",input$kategoria,"']/category/name")
    rv$kod_xml2 <- paste0("//styleguide/class[@type= '",input$kategoria,"']/category")
    rv$grupy <- rv$bjcp_beer_list %>% xml_find_all(rv$kod_xml) %>% xml_text()
    rv$grupy_id <- rv$bjcp_beer_list %>% xml_find_all(rv$kod_xml2) %>% xml_attr("id")
    output$grupyUI <- renderUI({
      selectInput("grupa","Wybierz grupe",rv$grupy)
      })
    })
  
  observeEvent(input$grupa,{
    rv$pos1 <- match(input$grupa,rv$grupy)
    rv$id_gr <- rv$grupy_id[rv$pos1]
    rv$kod_xml3 <- paste0("//styleguide/class[@type= '",input$kategoria,"']/category[@id = '",rv$id_gr,"']/subcategory/name")
    rv$kod_xml4 <- paste0("//styleguide/class[@type= '",input$kategoria,"']/category[@id = '",rv$id_gr,"']/subcategory")
    rv$style <- rv$bjcp_beer_list %>% xml_find_all(rv$kod_xml3) %>% xml_text()
    rv$style_id <- rv$bjcp_beer_list %>% xml_find_all(rv$kod_xml4) %>% xml_attr("id")
    output$styleUI <- renderUI({
      selectInput("styl","Wybierz styl",rv$style)
    })
  })
    
  
  observeEvent(input$styl,{
    output$nazwa1 <- renderText("Flavor")
    output$nazwa2 <- renderText("Appearance")
    output$nazwa3 <- renderText("Mouthfeel")
    output$nazwa4 <- renderText("Impression")
    output$nazwa5 <- renderText("Comments")
    output$nazwa6 <- renderText("History")
    output$nazwa7 <- renderText("Ingredients")
    output$nazwa8 <- renderText("Comparison")
    output$nazwa9 <- renderText("Examples")
    output$nazwa10 <- renderText("Instruction")
    
    
    rv$pos2 <- match(input$styl,rv$style)
    rv$id_st <- rv$style_id[rv$pos2]
    rv$kod_xml5 <- paste0("//styleguide/class[@type= '",input$kategoria,"']/category[@id = '",rv$id_gr,"']/subcategory[@id = '",rv$id_st,"']")
    
    rv$info_styl <- rv$bjcp_beer_list %>% xml_find_all(rv$kod_xml5) %>% as_list()
    
    output$name <- renderText(rv$info_styl[[1]]$name[[1]])
    output$flavor <- renderText(rv$info_styl[[1]]$flavor[[1]])
    output$appearance <- renderText(rv$info_styl[[1]]$appearance[[1]])
    output$mouthfeel <- renderText(rv$info_styl[[1]]$mouthfeel[[1]])
    output$impression <- renderText(rv$info_styl[[1]]$impression[[1]])
    output$comments <- renderText(rv$info_styl[[1]]$comments[[1]])
    output$history <- renderText(rv$info_styl[[1]]$history[[1]])
    output$ingredients <- renderText(rv$info_styl[[1]]$ingredients[[1]])
    output$comparison <- renderText(rv$info_styl[[1]]$comparison[[1]])
    output$examples <- renderText(rv$info_styl[[1]]$examples[[1]])
    output$instructions <- renderText(rv$info_styl[[1]]$entry_instructions[[1]])
    
    output$info <- renderPrint(paste0("IBU: ",rv$info_styl[[1]]$stats$ibu[[1]]
                ," | OG: ",rv$info_styl[[1]]$stats$og$low[[1]],"-",rv$info_styl[[1]]$stats$og$high[[1]]
                ," | FG: ",rv$info_styl[[1]]$stats$fg$low[[1]],"-",rv$info_styl[[1]]$stats$fg$high[[1]]
                ," | SRM: ",rv$info_styl[[1]]$stats$srm$low[[1]],"-",rv$info_styl[[1]]$stats$srm$high[[1]]
                ," | ABV: ",rv$info_styl[[1]]$stats$abv$low[[1]],"-",rv$info_styl[[1]]$stats$abv$high[[1]]
                ))
  })
  
  tl_polski <- function(plik){
    wynik <- translate2(plik, target_lang = "PL", source_lang = "EN", auth_key = "bb9dbc3c-1340-898d-24bb-ddf617876a18:fx")
    return(wynik)
  }
  
  observeEvent(input$tlumacz,{
    if(input$jezyk == "Polski") {
      output$nazwa1 <- renderText("Aromat")
      output$nazwa2 <- renderText("Wygląd")
      output$nazwa3 <- renderText("Odczucie w ustach")
      output$nazwa4 <- renderText("Wrażenie")
      output$nazwa5 <- renderText("Komentarz")
      output$nazwa6 <- renderText("Historia")
      output$nazwa7 <- renderText("Składniki")
      output$nazwa8 <- renderText("Porównanie")
      output$nazwa9 <- renderText("Przykłady")
      output$nazwa10 <- renderText("Wskazówki")

      output$flavor <- renderText(tl_polski(rv$info_styl[[1]]$flavor[[1]]))
      output$appearance <- renderText(tl_polski(rv$info_styl[[1]]$appearance[[1]]))
      output$mouthfeel <- renderText(tl_polski(rv$info_styl[[1]]$mouthfeel[[1]]))
      output$impression <- renderText(tl_polski(rv$info_styl[[1]]$impression[[1]]))
      output$comments <- renderText(tl_polski(rv$info_styl[[1]]$comments[[1]]))
      output$history <- renderText(tl_polski(rv$info_styl[[1]]$history[[1]]))
      output$ingredients <- renderText(tl_polski(rv$info_styl[[1]]$ingredients[[1]]))
      output$comparison <- renderText(tl_polski(rv$info_styl[[1]]$comparison[[1]]))

    } else {
      output$nazwa1 <- renderText("Flavor")
      output$nazwa2 <- renderText("Appearance")
      output$nazwa3 <- renderText("Mouthfeel")
      output$nazwa4 <- renderText("Impression")
      output$nazwa5 <- renderText("Comments")
      output$nazwa6 <- renderText("History")
      output$nazwa7 <- renderText("Ingredients")
      output$nazwa8 <- renderText("Comparison")
      output$nazwa9 <- renderText("Examples")
      output$nazwa10 <- renderText("Instruction")

      output$flavor <- renderText(rv$info_styl[[1]]$flavor[[1]])
      output$appearance <- renderText(rv$info_styl[[1]]$appearance[[1]])
      output$mouthfeel <- renderText(rv$info_styl[[1]]$mouthfeel[[1]])
      output$impression <- renderText(rv$info_styl[[1]]$impression[[1]])
      output$comments <- renderText(rv$info_styl[[1]]$comments[[1]])
      output$history <- renderText(rv$info_styl[[1]]$history[[1]])
      output$ingredients <- renderText(rv$info_styl[[1]]$ingredients[[1]])
      output$comparison <- renderText(rv$info_styl[[1]]$comparison[[1]])

    }
    

  })
  
  observeEvent(input$tag,{
    rv$subcat <- rv$bjcp_beer_list %>% xml_find_all(".//subcategory")
    
    rv$style_list <- c()
    rv$tag_list <- c()
    for(i in rv$subcat) {
      name_style <- i %>% xml_find_first(".//name") %>% xml_text()
      if(length(name_style) > 1){print(name_style)}
      atr_style <- i %>% xml_find_first(".//tags") %>% xml_text()
      atr_style <- strsplit(atr_style,", ")
      if(length(atr_style) == 0){atr_style <- ""}
      rv$style_list <- append(rv$style_list,name_style)
      rv$tag_list <- append(rv$tag_list,atr_style)
    }
    rv$show_style <- c()
    for (i in 1:length(rv$tag_list)) {
      if(all(input$tag %in% rv$tag_list[[i]])){
        rv$show_style <- append(rv$show_style,rv$style_list[i])
      }
    }
    output$tagi <- renderTable(rv$show_style, bordered = T, colnames = F)
  })
  
}
