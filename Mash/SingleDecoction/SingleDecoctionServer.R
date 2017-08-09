# Single Decoction Server

singleDecoctionServer <- function(input, output){
    #Reactive Variables:
    mashVol <- reactive({input$mashThickness*totalGrain()/4}) #[Qts/Lbs]*[Lbs]*[1Gal/4Qts] = Gal
    
    Tw <- reactive({
        #Tw is temperature of water being infused
        Tw <- (0.2/input$mashThickness)*(input$mashSaccRestTemp - input$mashGrainTemp)+input$mashSaccRestTemp
    })
     
    #Outputs:
    output$singleDecoctionMashThickness <- renderText({input$mashThickness}) #From water ui
    output$singleDecoctionMashVol <- renderText({
        mashVol()
    })
    output$singleDecoctionBoilTime <- renderText({input$boilTime}) #From main panel ui
    output$singleDecoctionTotalGrain <- renderText({totalGrain()}) #From fermentables server
    output$singleDecoctionInfusionTemp <- renderText({
        Tw()
    }) 
    output$singleDecoctionMashOutVolume <- renderText({
        #Wa is water added to mash out
        #Wa <- (170 - input$mashSaccRestTemp)*(0.2*totalGrain() + mashVol())/(212 - 170)
        Wa <- ((170-input$mashSaccRestTemp)/(212-170))*(0.2*totalGrain() + mashVol())/(1+(170-input$mashSaccRestTemp)/(212-170))
    }) 
    output$singleDecoctionStepMashPlot <- renderPlot({
        
        #times are in minutes
        grainSittingTime <- 5
        mashIn <- 3
        mashTime <- input$mashDuration
        mashOut <- 3
        sparge <- 30
        boilRise <- 45
        boil <- 60
        
        
        
        time <- c(1:(grainSittingTime),
                  (grainSittingTime+1):(grainSittingTime+mashIn),
                  (grainSittingTime+mashIn+1):(grainSittingTime+mashIn+mashTime),
                  (grainSittingTime+mashIn+mashTime+1):(grainSittingTime+mashIn+mashTime+mashOut),
                  (grainSittingTime+mashIn+mashTime+mashOut+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge),
                  (grainSittingTime+mashIn+mashTime+mashOut+sparge+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise),
                  (grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise+boil)) 
        
        mashTemp <- c(rep(input$mashGrainTemp, grainSittingTime),
                      seq(input$mashGrainTemp, input$mashSaccRestTemp, length.out = mashIn),
                      rep(input$mashSaccRestTemp, mashTime),
                      seq(input$mashSaccRestTemp, 170, length.out = mashOut),
                      rep(170, sparge),
                      seq(170, 212, length.out = boilRise),
                      rep(212, boil))
        infusionTemp <- c(rep(Tw(), grainSittingTime),
                          seq(Tw(), input$mashSaccRestTemp, length.out = mashIn),
                          rep(NA, mashTime),
                          rep(NA, mashOut),
                          rep(NA, sparge),
                          rep(NA, boilRise),
                          rep(NA, boil))
        mashOutTemp <- c(rep(NA, grainSittingTime),
                         rep(NA, mashIn),
                         rep(NA, mashTime-30),#take sum of rise time and boil time off of mash time
                         seq(input$mashSaccRestTemp, 212, length.out = 10), #rise time assumed to be 10 min
                         rep(212,20), #boil for ten min
                         seq(212, 170, length.out = mashOut),
                         rep(NA, sparge),
                         rep(NA, boilRise),
                         rep(NA, boil))
        
        data <- data.frame(Time = time,
                           mashTemp = mashTemp,
                           infusionTemp = infusionTemp,
                           mashOutTemp = mashOutTemp)
        
        dataLong <- data %>% gather("Volumes", "Temp", 2:4)
        
        mashGraph <- ggplot(dataLong, aes(Time, Temp, group = Volumes, color = Volumes))
        mashGraph + geom_line(size = 2) 
        
        
    })    
}