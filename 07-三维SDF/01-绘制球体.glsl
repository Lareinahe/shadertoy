// 坐标系缩放
#define PROJECTION_SCALE  1.

// 球体的球心位置
#define SPHERE_POS vec3(0, 0, -2)
// 球体的半径
#define SPHERE_R 1.0
// 球体的漫反射系数
#define SPHERE_KD vec3(1)

// 相机视点位
#define CAMERA_POS vec3(0, 0, 2)
// 近裁剪距离
#define CAMERA_NEAR 0.1
// 远裁剪距离
#define CAMERA_FAR 128.

// 光线推进次数
#define RAYMARCH_TIME 20
// 当推进后的点位距离物体表面小于RAYMARCH_PRECISION时，默认此点为物体表面的点
#define RAYMARCH_PRECISION 0.001

// 投影坐标系
vec2 ProjectionCoord(in vec2 coord) {
  return PROJECTION_SCALE * 2. * (coord - 0.5 * iResolution.xy) / min(iResolution.x, iResolution.y);
}

//从相机视点到片元的射线
vec3 RayDir(in vec2 coord) {
  return normalize(vec3(coord, 0) - CAMERA_POS);
}

//球体的SDF模型
float SDFSphere(vec3 coord) {
  return length(coord - SPHERE_POS) - SPHERE_R;
}

// 光线推进
vec3 RaySphere(vec2 coord) {
  float d = CAMERA_NEAR;
  // 从相机视点到当前片元的射线
  vec3 rd = RayDir(coord);
  // 片元颜色
  vec3 color = vec3(0);
  for(int i = 0; i < RAYMARCH_TIME && d < CAMERA_FAR; i++) {
    // 光线推进后的点位
    vec3 p = CAMERA_POS + d * rd;
    // 光线推进后的点位到球体的有向距离
    float curD = SDFSphere(p);
    // 若有向距离小于一定的精度，默认此点在球体表面
    if(curD < RAYMARCH_PRECISION) {
      color = SPHERE_KD;
      break;
    }
    // 距离累加
    d += curD;
  }
  return color;
}

/* 绘图函数，画布中的每个片元都会执行一次，执行方式是并行的。
fragColor 输出参数，用于定义当前片元的颜色。
fragCoord 输入参数，当前片元的位置，原点在画布左下角，右侧边界为画布的像素宽，顶部边界为画布的像素高
*/
void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  // 当前片元的栅格图像位
  vec2 coord = ProjectionCoord(fragCoord.xy);
  // 光线推进
  vec3 color = RaySphere(coord);
  // 最终颜色
  fragColor = vec4(color, 1);
}