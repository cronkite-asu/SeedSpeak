using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;

namespace SeedSpeak
{
    public class ImageResize
    {
        //private ImageResize()
        //{ }

        //Scale the image to a percentage of its actual size.
        public static Image ScaleByPercentage(Image img, double percent)
        {
            double fractionalPercentage = (percent / 100.0);
            int outputWidth = (int)(img.Width * fractionalPercentage);
            int outputHeight = (int)(img.Height * fractionalPercentage);
            return ImageResize.ScaleImage(img, outputWidth, outputHeight);
        }

        //Scale down the image till it fits the given size.
        public static Image ScaleDownTillFits(Image img, Size size)
        {
            Image ret = img;
            bool bFound = false;
            if ((img.Width > size.Width) || (img.Height > size.Height))
            {
                for (double percent = 100; percent > 0; percent--)
                {
                    double fractionalPercentage = (percent / 100.0);
                    int outputWidth = (int)(img.Width * fractionalPercentage);
                    int outputHeight = (int)(img.Height * fractionalPercentage);
                    if ((outputWidth < size.Width) && (outputHeight < size.Height))
                    {
                        bFound = true;
                        ret = ImageResize.ScaleImage(img, outputWidth, outputHeight);
                        break;
                    }
                }

                if (!bFound)
                {
                    ret = ImageResize.ScaleImage(img, size.Width, size.Height);
                }
            }
            return ret;
        }

        //Scale an image by a set width. The height will be set proportionally.
        public static Image ScaleByWidth(Image img, int width)
        {
            double fractionalPercentage = ((double)width / (double)img.Width);
            int outputWidth = width;
            int outputHeight = (int)(img.Height * fractionalPercentage);
            return ImageResize.ScaleImage(img, outputWidth, outputHeight);
        }

        //Scale an image by a set height. The width will be set proportionally.
        public static Image ScaleByHeight(Image img, int height)
        {
            double fractionalPercentage = ((double)height / (double)img.Height);
            int outputWidth = (int)(img.Width * fractionalPercentage);
            int outputHeight = height;
            return ImageResize.ScaleImage(img, outputWidth, outputHeight);
        }

        //Scale an image to a given width and height.
        public static Image ScaleImage(Image img, int outputWidth, int outputHeight)
        {
            Bitmap outputImage = new Bitmap(outputWidth, outputHeight, img.PixelFormat);
            outputImage.SetResolution(img.HorizontalResolution, img.VerticalResolution);
            Graphics graphics = Graphics.FromImage(outputImage);
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            graphics.DrawImage(img, new Rectangle(0, 0, outputWidth, outputHeight),
            new Rectangle(0, 0, img.Width, img.Height), GraphicsUnit.Pixel);
            graphics.Dispose();
            return outputImage;
        }

        //Source folder images
        public void ResizeImagesInFolder(string SourceFolder, string DestinationFolder, int NewImageSize)
        {
            // Check if source folder exists and throw exception if not
            if (!Directory.Exists(SourceFolder))
                throw new Exception("SourceFolder does not exist");

            // Check if destination folder exists, but create it if not
            if (!Directory.Exists(DestinationFolder))
            {
                Directory.CreateDirectory(DestinationFolder);
            }

            // List all images from source directory
            DirectoryInfo diImages = new DirectoryInfo(SourceFolder);
            ArrayList alImages = new ArrayList();
            // GetFiles method doesn't allow us to filter for multiple 
            // file extensions, so we must find images in four steps
            // Feel free to add new or remove existing extension to 
            // suit your needs
            
            //alImages.AddRange(diImages.GetFiles("*.gif"));
            alImages.AddRange(diImages.GetFiles("*.jpg"));
            //alImages.AddRange(diImages.GetFiles("*.bmp"));
            alImages.AddRange(diImages.GetFiles("*.png"));

            Image imgOriginal;
            float OriginalHeight;
            float OriginalWidth;
            int NewWidth;
            int NewHeight;
            Bitmap ResizedBitmap;
            Graphics ResizedImage;

            // Resize every image
            foreach (FileInfo fiImage in alImages)
            {
                // Loads original image from source folder
                imgOriginal = Image.FromFile(fiImage.FullName);
                // Finds height and width of original image
                OriginalHeight = imgOriginal.Height;
                OriginalWidth = imgOriginal.Width;
                // Finds height and width of resized image
                if (OriginalHeight > OriginalWidth)
                {
                    NewHeight = NewImageSize;
                    NewWidth = (int)((OriginalWidth / OriginalHeight) * (float)NewImageSize);
                }
                else
                {
                    NewWidth = NewImageSize;
                    NewHeight = (int)((OriginalHeight / OriginalWidth) * (float)NewImageSize);
                }
                NewHeight = 64;
                NewWidth = 64;
                // Create new bitmap that will be used for resized image
                ResizedBitmap = new Bitmap(NewWidth, NewHeight);
                ResizedImage = Graphics.FromImage(ResizedBitmap);
                // Resized image will have best possible quality
                ResizedImage.InterpolationMode = InterpolationMode.HighQualityBicubic;
                ResizedImage.CompositingQuality = CompositingQuality.HighQuality;
                ResizedImage.SmoothingMode = SmoothingMode.HighQuality;
                // Draw resized image
                ResizedImage.DrawImage(imgOriginal, 0, 0, NewWidth, NewHeight);
                // Save thumbnail to file
                ResizedBitmap.Save(DestinationFolder + fiImage.Name);

                // It is important to take care of memory, especially in cases 
                // when code works with graphics
                imgOriginal.Dispose();
                ResizedBitmap.Dispose();
                ResizedImage.Dispose();
            }
        }
    }
}
