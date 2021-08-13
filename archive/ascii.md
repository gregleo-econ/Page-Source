+1

# ASCII GDP

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
library(txtplot)
library(fredr)
fredr_set_key("b94eaa72a60498e015decf15e0aeed9d")
data <- fredr_series_observations(series_id = "GDP") 
```

## ASCII GDP Data

```{r cars}
txtplot(as.numeric(data$date),as.numeric(data$value),width=75)
```

