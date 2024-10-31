//
//  MainViewController.m
//  VideoEditStart
//
//  Created by leozbzhang on 2024/10/30.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) EAGLContext *mContext;

@property (nonatomic , strong) GLKBaseEffect* mEffect;


@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initContext];
    
    [self buildVertexArray];
    
    [self upLoadText];
    
}

- (void)initContext
{
    // 0 上下文创建绑定
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = (GLKView *)self.view;
    view.context = self.mContext;
    //颜色缓冲区格式
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    [EAGLContext setCurrentContext:self.mContext];
}

/// 顶点数据
- (void)buildVertexArray
{
    
    //TODO:leo 怎么理解这个坐标
    //顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    };
    
    //顶点数据缓存
    GLuint buffer;
    // glGenBuffers申请一个标识符
    glGenBuffers(1, &buffer);
    // glBindBuffer把标识符绑定到GL_ARRAY_BUFFER上
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    // glBufferData把顶点数据从cpu内存复制到gpu内存
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    
    // glVertexAttribPointer设置合适的格式从buffer里面读取数据
    //顶点数据缓存
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);
    //纹理
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
        
}

/// 纹理
- (void)upLoadText
{
    //纹理贴图
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    //GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft,nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    // 着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
            
}

// 渲染场景代码
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(255.0f, 255.0f, 255.0f, 1.0f); // 这里的参数是默认背景颜色
    glClear(GL_COLOR_BUFFER_BIT| GL_DEPTH_BUFFER_BIT);
    
    // 启动着色器
    [self.mEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);    
}


@end
