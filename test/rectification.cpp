//
// Created by Admin on 2018/10/9.
//
#include <iostream>
#include <vector>
#include <opencv2/opencv.hpp>

#define showWindow(mat) { \
    namedWindow("Source Image", 0); \
    resizeWindow("Source Image", 360, 600); \
    imshow("Source Image", mat); \
}
using namespace std;
using namespace cv;


Point2f srcTri[4],dstTri[4];
int clickTimes=0;  //在图像上单击次数
Mat image;
Mat imageWarp;

void onMouse(int event,int x,int y,int flags,void *utsc)
{
    if(event==CV_EVENT_LBUTTONUP)   //响应鼠标左键抬起事件
    {
        circle(image,Point(x,y),2.5,Scalar(0,0,255),2.5);  //标记选中点
        showWindow(image);
        srcTri[clickTimes].x=x;
        srcTri[clickTimes].y=y;
        clickTimes++;
    }
    if(clickTimes==4)
    {
        dstTri[0].x=0;
        dstTri[0].y=0;
        dstTri[1].x=image.rows-1;
        dstTri[1].y=0;
        dstTri[2].x=0;
        dstTri[2].y=image.cols-161;
        dstTri[3].x=image.rows-1;
        dstTri[3].y=image.cols-161;
        Mat transform=Mat::zeros(3,3,CV_32FC1); //透视变换矩阵
        transform=getPerspectiveTransform(srcTri,dstTri);  //获取透视变换矩阵
        warpPerspective(image,imageWarp,transform,Size(image.rows,image.cols-160));  //透视变换
        namedWindow("After WarpPerspecttive", WINDOW_NORMAL);
        resizeWindow("After WarpPerspecttive", 360, 600);
        imshow("After WarpPerspecttive",imageWarp);
    }
}
int main() {

    image = imread("d:/Admin/Pictures/3333.jpg");
    showWindow(image)
    setMouseCallback("Source Image",onMouse);
    waitKey(0);
    return 0;
}
