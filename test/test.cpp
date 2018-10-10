//#include <iostream>
//#include <opencv2/opencv.hpp>
//
//#define CV_SHOW(img) imshow("test", img)
//using namespace cv;
//using namespace std;
//
//
//static void testImageRectification(cv::Mat &image_original) {
//    double g_threshVal = 100;
//    double g_threshMax = 255;
//    CV_SHOW(image_original); // CV_SHOW是cv::imshow的一个自定义宏，忽略即可
//    cv::Mat &&image = image_original.clone();
//    cv::Mat image_gray;
//    cv::cvtColor(image, image_gray, cv::COLOR_BGR2GRAY);
//    cv::threshold(image_gray, image_gray, g_threshVal, g_threshMax, cv::THRESH_BINARY);
//    std::vector<std::vector<cv::Point> > contours_list;
//    {
//        std::vector<cv::Vec4i> hierarchy;        // Since opencv 3.2 source image is not modified by this function
//        cv::findContours(image_gray, contours_list, hierarchy, cv::RetrievalModes::RETR_EXTERNAL,
//                         cv::ContourApproximationModes::CHAIN_APPROX_NONE);
//    }
//    for (uint32_t index = 0; index < contours_list.size(); ++index) {
//        cv::RotatedRect &&rect = cv::minAreaRect(contours_list[index]);
//        if (rect.size.area() > 1000) {
//            if (rect.angle != 0.) {                // 此处可通过cv::warpAffine进行旋转矫正，本例不需要
//            } //if
//            cv::Mat &mask = image_gray;
//            cv::drawContours(mask, contours_list, static_cast<int>(index), cv::Scalar(255), cv::FILLED);
//            cv::Mat extracted(image_gray.rows, image_gray.cols, CV_8UC1, cv::Scalar(0));
//            image.copyTo(extracted, mask);
//            CV_SHOW(extracted);
//            std::vector<cv::Point2f> poly;
//            cv::approxPolyDP(contours_list[index], poly, 30, true); // 多边形逼近，精度(即最小边长)设为30是为了得到4个角点
//            cv::Point2f pts_src[] = { // 此处顺序调整是为了和后面配对，仅作为示例
//                    poly[1], poly[0], poly[3], poly[2]};
//            cv::Rect &&r = rect.boundingRect(); // 注意坐标可能超出图像范围
//            cv::Point2f pts_dst[] = {cv::Point(r.x, r.y), cv::Point(r.x + r.width, r.y),
//                                     cv::Point(r.x + r.width, r.y + r.height), cv::Point(r.x, r.y + r.height)};
//            cv::Mat &&M = cv::getPerspectiveTransform(pts_dst,
//                                                      pts_src); // 我这里交换了输入，因为后面指定了cv::WARP_INVERSE_MAP，你可以试试不交换的效果是什么
//            cv::Mat warp;
//            cv::warpPerspective(image, warp, M, image.size(), cv::INTER_LINEAR + cv::WARP_INVERSE_MAP,
//                                cv::BORDER_REPLICATE);
//             CV_SHOW(warp);
//        } //if
//    }
//}
//
//Point2f srcTri[3];
//Point2f dstTri[3];
//Mat rot_mat(2, 3, CV_32FC1);
//Mat warp_mat(2, 3, CV_32FC1);
//Mat src, warp_dst, warp_rotate_dst;
//
//int test(Mat &origin) {
//    src = origin;
//    warp_dst = Mat::zeros(src.rows, src.cols, src.type());
//
//    srcTri[0] = Point2f(0, 0);
//    srcTri[1] = Point2f(src.cols - 1, 0);
//    srcTri[2] = Point2f(0, src.rows - 1);
//    dstTri[0] = Point2f(src.cols * 0.0, src.rows * 0.33);
//    dstTri[1] = Point2f(src.cols * 0.85, src.rows * 0.25);
//    dstTri[2] = Point2f(src.cols * 0.15, src.rows * 0.7);
//
//    warp_mat = getAffineTransform(srcTri, dstTri);
//    warpAffine(src, warp_dst, warp_mat, warp_dst.size());
//
//    Point center = Point(warp_dst.cols / 2, warp_dst.rows / 2);
//    double angle = -50.0;
//    double scale = 0.6;
//    rot_mat = getRotationMatrix2D(center, angle, scale);
//
//    warpAffine(warp_dst, warp_rotate_dst, rot_mat, warp_dst.size());
//
//    namedWindow("src", WINDOW_AUTOSIZE);
//    imshow("src", src);
//
//    namedWindow("wrap_dst", WINDOW_AUTOSIZE);
//    imshow("wrap_dst", warp_dst);
//
//    namedWindow("rotate_dst", WINDOW_AUTOSIZE);
//    imshow("rotate_dst", warp_rotate_dst);
//    return 0;
//}
//
//void extractTable(const char *argv) {
//    Mat src = imread(argv), dst;
//    if (!src.data) {
//        cout << "not picture" << endl;
//    }
//    Mat canny, gray, sobel, edge, erod, blur, color_dst;
//
//    double src_height = src.cols, src_width = src.rows;
//    imshow("source", src);
//
//    //先转为灰度
//    cvtColor(src, gray, COLOR_BGR2GRAY);
//
//    //腐蚀（黑色区域变大）
//    int erodeSize = src_height / 200;
//    if (erodeSize % 2 == 0)
//        erodeSize++;
//    Mat element = getStructuringElement(MORPH_RECT, Size(erodeSize, erodeSize));
//    erode(gray, erod, element);
//
//    //高斯模糊化
//    int blurSize = src_height / 200;
//    if (blurSize % 2 == 0)
//        blurSize++;
//    GaussianBlur(erod, blur, Size(blurSize, blurSize), 0, 0);
//    namedWindow("GaussianBlur", WINDOW_NORMAL);
//    imshow("GaussianBlur", blur);
//
//    //自适应阈值Cannyz算法
//    double low = 0.0, high = 0.0;
//    // AdaptiveFindThreshold(src, &low, &high);
//    Canny(blur, canny, low, high);
//
//    imshow("gray", gray);
//    imshow("canny", canny);
//
//    //检测直线，并将直线放回原图
//    vector<Vec4i> lines;
//    HoughLinesP(canny, lines, 1, CV_PI / 180, 100, 100, 15);
//    cout << "线条数" << lines.size() << endl;
//    for (size_t i = 0; i < lines.size(); i++) {
//        line(src, Point(lines[i][0], lines[i][1]),
//             Point(lines[i][2], lines[i][3]), Scalar(0, i * 10 & 255, (255 - i * 10) & 255), 3, 8);
//    }
//
//    imshow("Detected Lines", src);
//    waitKey(0);
//    destroyAllWindows();
//}
//#define path "D:/Admin/Pictures/test.jpg"
//
//int test1(Mat &mat) {
//
//    Mat src = mat;
//    if (!src.data) return 0;
//    int width = src.cols;
//    int height = src.rows;
//    Point2f src_vertices[4];
//    src_vertices[0] = Point(0, 0);
//    src_vertices[1] = Point(width, 0);
//    src_vertices[2] = Point(0, height);
//    src_vertices[3] = Point(width, height);
//    Point2f dst_vertices[4];
//    dst_vertices[0] = Point(0, 0);
//    dst_vertices[1] = Point(width, 0);
//    dst_vertices[2] = Point(0, height);
//    dst_vertices[3] = Point(width, height / 2);    //透视变换
//    Mat warpMatrix = getPerspectiveTransform(src_vertices, dst_vertices);
//    Mat warped;
//    warpPerspective(src, warped, warpMatrix, warped.size(), INTER_LINEAR, BORDER_CONSTANT);
//    namedWindow("src");
//    imshow("src", src);
//    namedWindow("warp perspective");
//    imshow("warp perspective", warped);
//    imwrite("warped.jpg", warped);
//    waitKey();
//
//
//}
//
//#define PRINT(desc) cout << desc << endl
////int main() {
////    std::cout << "111" << std::endl;
////    Mat mat = imread(path, IMREAD_UNCHANGED);
////    testImageRectification(mat);
////    PRINT("Hello, World!");
////
////    waitKey(0);
////    return 0;
////}