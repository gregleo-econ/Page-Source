+3

# How I Generate This Webpage

I generate this site from a directory of markdown files using a script written in R. The code for this and some instructions are given below. 


## Set up your directory. 

Your directory should have a folder called "markdown". This folder must contain one folder for each category of page you want on the index page of the site. I have, for instance "papers" and "teaching" as subfolders. Each subfolder must have one markdown file per page you want on the site. The markdown files should start with a single blank line and then a header `# Title`. This header will be used as the title of the page on the index.  


Pull the code from "Background Code" into a .R file in your directory and save it as "background.R". You might also want to put a styleshee (css) file in the directory as well. I keep mine in a /style subdirectory. The content of my stylesheet is also provided below. 

## Running the code.

To generate your site, run the following code. Make sure to replace the path in the directory variable with the path to the directory you are setting up your site in. Also make sure to update the page title! You might also need to update the path to your stylesheet if you have placed it somewhere other than a /style subdirectory or called it something other than style.css.

```{r,running,eval=FALSE,echo=TRUE}
directory="c://webpage"
setwd(directory)
source("background.R")
style = paste(c(directory,"//style/style.css"),collapse="")
pageTitle = "Greg Leo"
makePage(directory,style,pageTitle)
```
After you run this code, your site will be built in the /static directory. Enjoy!

## Background Code

```{r,pageMaker,eval=FALSE,echo=TRUE}
library(knitr)
library(fs)
library(stringr)
library(dplyr)
library(stringi)
library(magrittr)

list.dirs <- function(path = ".",
                      pattern = NULL,
                      all.dirs = FALSE,
                      full.names = FALSE,
                      ignore.case = FALSE) {
  # use full.names=TRUE to pass to file.info
  all <- list.files(path,
                    pattern,
                    all.dirs,
                    full.names = TRUE,
                    recursive = FALSE,
                    ignore.case)
  dirs <- all[file.info(all)$isdir]
  # determine whether to return full names or just dir names
  if (isTRUE(full.names))
    return(dirs)
  else
    return(basename(dirs))
}

#Get Folders in Markdown Directory
getFolders <- function(directory) {
  markdownDirectory = paste(c(directory, "//markdown"), collapse = "")
  folders = list.dirs(markdownDirectory)
}

#Get Files in Markdown Directory Folder
getFiles <- function(folder, directory) {
  markdownDirectory = paste(c(directory, "//markdown"), collapse = "")
  staticDirectory = paste(c(directory, "//static"), collapse = "")
  currentDirectoryMarkdown = paste(c(markdownDirectory, "//", folder), collapse =
                                     "")
  currentDirectory = paste(c(staticDirectory, "//", folder), collapse =
                             "")
  temp = list.files(currentDirectoryMarkdown, pattern = "*.md$")
  temp
}

#Extract Page Title from File
getTitle <- function(file) {
  pageTitle <- str_extract(readChar(file, 500), regex("# .*"))
  pageTitle <- substring(pageTitle, 3)
  pageTitle
}


#Extract Page Title from File
getPriority <- function(file) {
  priority <- str_extract(readChar(file, 10), regex("[0-9]{1,10}"))
  priority
}


#Add a "back" link to each page.
addBack <- function(fileInfo){
  content <- fileInfo$content
  content <- paste("[Back](../index.html)  \n\n\n", content, collapse = "")
  fileInfo$content <- content
  fileInfo
}

#Setup the Static Folder
makeStaticFolder <- function(folder, directory) {
  staticDirectory = paste(c(directory, "//static"), collapse = "")
  currentDirectory = paste(c(staticDirectory, "//", folder), collapse =
                             "")
  dir.create(currentDirectory)
}
setupStatic <- function(directory, Ffolders) {
  sapply(folders, makeStaticFolder, directory = directory)
}

#Setup the Temp Folder
setupTemp <- function(directory) {
  tempDirectory = paste(c(directory, "//temp"), collapse = "")
  dir.create(tempDirectory)
}

#Get Full Path to Markdown File
getMarkdownPath <- function(file, folder, directory) {
  paste(c(directory, "//markdown//", folder, "//", file), collapse = "")
}

#Get Full Path to Static File
getStaticPath <- function(file, folder, directory) {
  paste(c(
    directory,
    "//static//",
    folder,
    "//",
    substr(file, 1, nchar(file) - 2),
    "html"
  ),
  collapse = "")
}

#Make a Link to the Static File in Markdown Format
makeLink <- function(fileInfo) {
  paste(c(
    "[",
    fileInfo$title,
    "](",
    fileInfo$folder,
    "/",
    substr(fileInfo$fileName, 1, nchar(fileInfo$fileName) - 2),
    "html)\n"
  ),
  collapse = "")
}

#Create the Index Page
makeIndex <- function(fileData,pageTitle) {
  indexText <- c(paste("# ",pageTitle,sep=""))
  folders <- fileData %>% pull(folder) %>% unique
  for(currentFolder in folders){
    indexText <- c(indexText,paste("## ",toupper(substring(currentFolder,3)),sep=""))
    subsetFiles <- fileData %>% filter(folder==currentFolder) %>% arrange(desc(priority))
    for(i in 1:dim(subsetFiles)[1]){
      
      indexText <- c(indexText,makeLink(subsetFiles[i,]))
    }
  }
  writeLines(indexText, paste(directory, "//markdown//index.md", sep = ""))
  knit2html(
    paste(directory, "//markdown//index.md", sep = ""),
    paste(directory, "//static//index.md", sep = ""),
    stylesheet = style
  )
}

#Add a "back" link to each page.
addBack <- function(fileInfo){
  content <- fileInfo$content
  content <- 
  content <- paste("[Back](../index.html) \r\n", content, collapse = "")
  fileInfo$content <- content
  fileInfo
}

#Create an HTML Page from Markdown File
makeHtml <- function(fileInfo,style,directory) {
  message("Making",fileInfo$title)
  fileInfo <- addBack(fileInfo)
  tempFile <- paste(directory, "//temp//temp",stri_rand_strings(1,1),".md", sep = "")
  writeLines(fileInfo$content, tempFile, sep = "")
  knit2html(tempFile, output=fileInfo$fullStaticPath, stylesheet = style)
  setwd(directory)
}


#Remove Priority String
removePriority <- function(content){
  content <- str_remove(content,"[+][0-9]{1,10}\r\n")
  content
}


#Parse the files and make a dataframe with relevant file info. 
makeFileData <- function(directory){
  fileName=c()
  folder=c()
  fullMarkdownPath=c()
  fullStaticPath=c()
  title=c()
  content=c()
  priority <- c()
  folders <- getFolders(directory)
  for (fileFolder in folders) {
    files <- getFiles(fileFolder, directory)
    for(file in files){
    fileMarkdownPath <- getMarkdownPath(file,fileFolder,directory)
    fileStaticPath <- getStaticPath(file,fileFolder,directory)
    fileTitle <- getTitle(fileMarkdownPath)  
    filePriority <- as.numeric(getPriority(fileMarkdownPath))
    fileContent <- readChar(fileMarkdownPath, file.info(fileMarkdownPath)$size)
    fileContent <- removePriority(fileContent)
    priority <- c(priority,filePriority)
    fileName <- c(fileName,file)
    folder <- c(folder,fileFolder)
    fullMarkdownPath <- c(fullMarkdownPath,fileMarkdownPath)
    fullStaticPath <- c(fullStaticPath,fileStaticPath)
    title <- c(title,fileTitle)
    content <- c(content,fileContent)
    }
  }
  return(data.frame(fileName = fileName,folder = folder,fullMarkdownPath = fullMarkdownPath,fullStaticPath = fullStaticPath,title = title,priority = priority,content = content))
}


#Make sure the directory structure of the site is ok. 
setupSite <- function(directory){
  setwd(directory)
  dir.create(paste(c(directory, "//static//"), collapse = ""))
  folders <- getFolders(directory)
  setupTemp(directory)
  setupStatic(directory, folders)
}


#Put it All Together to Make Page
makePage <- function(directory, style,pageTitle) {
  setupSite(directory)
  fileData <- makeFileData(directory)
  for(i in 1:dim(fileData)[1]){makeHtml(fileData[i,],style = style,directory=directory)}
  makeIndex(fileData,pageTitle)
}

```

## Style Sheet

```{r,style,eval=FALSE,echo=TRUE}
@import url('https://fonts.googleapis.com/css2?family=Share+Tech+Mono&display=swap');
body {
	background: #2637dd;
	font-family: "Roboto Mono", monospace;
	font-weight: 500;
	color: #fff;
	-webkit-font-smoothing: antialiased;
	font-size: 12pt;
	width: 900px;
	line-height: 16pt;
	padding-left: 5pt;
	padding-right: 5pt;
	padding-top: 5pt;
	margin: auto;
}

main h1 {}

h1 {
	font-family: "Rubik Mono One", sans-serif;
	background: #fff;
	color: #2637dd;
	padding: 0.1em 0.3em;
	font-size: 1.2em;
	text-transform: uppercase;
	display: inline-block;
	margin-top: 15px;
	margin-bottom: 10px;
	font-weight: bold;
	line-height: 20pt;
}

h2 {
	font-family: "Rubik Mono One", sans-serif;
	background: #fff;
	color: #2637dd;
	padding: 0.1em 0.3em;
	font-size: 1em;
	text-transform: uppercase;
	margin-top: 15px;
	margin-bottom: 10px;
	font-weight: bold;
	line-height: 20pt;
}

h3 {
	margin-top: 15px;
	margin-bottom: 5px;
}

h4 {
	margin-top: 15px;
	margin-bottom: 5px;
}

title {
	font-weight: bold;
	line-height: 20pt;
}

p.subheader {
	font-weight: bold;
	color: #593d87;
}

img {
	padding: 3pt;
	float: right;
}

a {
	color: #ffffff;
	color: inherit;
	text-shadow: 1px 1px #2637dd, -1px -1px #2637dd;
	text-decoration: underline;
}

a:link,
a:visited {
	color: #ffffff;
}

pre {
	overflow-x: auto;
	white-space: pre-wrap;
	white-space: -moz-pre-wrap;
	white-space: -pre-wrap;
	white-space: -o-pre-wrap;
	word-wrap: break-word;
	padding: 2px 5px;
	color: #000000;
	background: #fff;
	font-family: inherit;
}

a:hover,
a:active {
	text-decoration: none;
	text-decoration: line-through;
}

p {
	margin: 0px;
}

div.footer {
	font-size: 9pt;
	font-style: italic;
	line-height: 12pt;
	text-align: center;
	padding-top: 30pt;
}
```