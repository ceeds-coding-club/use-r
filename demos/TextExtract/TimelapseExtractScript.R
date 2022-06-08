# text extraction from video/images ---------------------------------------

library(av)
library(magick)
library(tesseract)

### path for folder containing all videos
### set path as working directory
path<-(choose.dir())
setwd(path)

# loop through videos splitting into images -------------------------------

videos<-list.files(path=path, pattern="*.mp4")

for(f in videos) {
  av_video_images(f, destdir=paste0(path, "/", gsub(".mp4", "images", f)), format="png")
}


# text extraction ---------------------------------------------------------


### select folder
folder<-paste0("examplevid" , "images")

### make a list of image files
files<-list.files(path=paste0(path, "/",folder), pattern="*.png")

### make a starting data frame (empty with only column names)
output<-data.frame(matrix(ncol=8,nrow=0, dimnames=list(NULL, c("c8", "c1", "c2", "c3", "c4", "c5", "c6", "c7"))))

### check cropping on 1st image (need to look at each crop and alter location)
img<-image_read(paste0(path, "/", folder, "/", "image_000001.png"))

##### width ##### height ##### x coord ##### y coord #####
image_crop(img, "200x100+290+150") # crop1
image_crop(img, "200x100+290+240") # crop2
image_crop(img, "200x100+290+325") # crop3
image_crop(img, "200x100+290+420") # crop4
image_crop(img, "200x100+930+145") # crop5
image_crop(img, "200x100+930+235") # crop6
image_crop(img, "200x100+930+330") # crop7
image_negate(image_crop(img, "340x30+530+703")) # timestamp

### need to reset working directory to current folder
setwd(paste0(path, "/", folder))

### whitelist (for values)
whitelist1 <- tesseract(options = list(tessedit_char_whitelist = ".0123456789"))
### whitelist (for timestamp)
whitelist2 <- tesseract(options = list(tessedit_char_whitelist = ".:/0123456789"))


# optical character recognition loop --------------------------------------

for (f in files) {
  ### read in each image
  img <- image_read(f)
  ### crop diff parts of image ### REMEMBER TO MATCH THESE CROPS TO ABOVE
  crop1<-image_crop(img, "200x100+290+150")
  crop2<-image_crop(img, "200x100+290+240")
  crop3<-image_crop(img, "200x100+290+325")
  crop4<-image_crop(img, "200x100+290+420")
  crop5<-image_crop(img, "200x100+930+145")
  crop6<-image_crop(img, "200x100+930+235")
  crop7<-image_crop(img, "200x100+930+330")
  crop8<-image_negate(image_crop(img, "340x30+530+703"))
  ### extract text from crops and remove \n
  c1<-gsub("[\n]", "",ocr(crop1, engine=whitelist1))
  c2<-gsub("[\n]", "",ocr(crop2, engine=whitelist1))
  c3<-gsub("[\n]", "",ocr(crop3, engine=whitelist1))
  c4<-gsub("[\n]", "",ocr(crop4, engine=whitelist1))
  c5<-gsub("[\n]", "",ocr(crop5, engine=whitelist1))
  c6<-gsub("[\n]", "",ocr(crop6, engine=whitelist1))
  c7<-gsub("[\n]", "",ocr(crop7, engine=whitelist1))
  c8<-gsub("[\n]", "",ocr(crop8, engine=whitelist2))
  ### make a data frame of extracted text
  extracted<-data.frame(f, c8, c1, c2, c3, c4, c5, c6, c7)
  ### add data frame to starting data frame
  output<-rbind(output, extracted)
  ### print image to show progress
  print(f)
}
### give columns descriptive titles
colnames(output) <- c("ImageNumber", "Timestamp", "Temp", "SetTemp", "RH", "SetRH", "CO2", "SetCO2", "Light")

### export as csv
write.csv(output, file=paste0(path, "/", folder, ".csv"))
