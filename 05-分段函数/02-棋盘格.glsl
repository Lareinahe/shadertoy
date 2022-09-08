// 投影坐标系
vec2 ProjectionCoord(in vec2 coord, in float scale) {
  return scale * 2. * (coord - 0.5 * iResolution.xy) / min(iResolution.x, iResolution.y);
}

// 坐标轴
vec4 AxisHelper(in vec2 coord, in float axisWidth, in vec4 xAxisColor, in vec4 yAxisColor) {
  vec4 color = vec4(0, 0, 0, 0);
  float dx = dFdx(coord.x) * axisWidth;
  float dy = dFdy(coord.y) * axisWidth;
  if(abs(coord.x) < dx) {
    color = yAxisColor;
  } else if(abs(coord.y) < dy) {
    color = xAxisColor;
  }
  return color;
}

// 栅格
vec4 GridHelper(in vec2 coord, in vec4 gridColor1, in vec4 gridColor2) {
  vec2 g = floor(mod(coord, 2.));
  return g.x == g.y ? gridColor1 : gridColor2;
}

// 投影坐标系辅助对象
vec4 ProjectionHelper(in vec2 coord, in float axisWidth, in vec4 xAxisColor, in vec4 yAxisColor, in vec4 gridColor1, in vec4 gridColor2) {
  // 坐标轴
  vec4 axisHelper = AxisHelper(coord, axisWidth, xAxisColor, yAxisColor);
  // 栅格
  vec4 gridHelper = GridHelper(coord, gridColor1, gridColor2);
  // =投影坐标系
  return bool(axisHelper.a) ? axisHelper : gridHelper;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  // 投影坐标
  vec2 coord = ProjectionCoord(fragCoord, 3.);
  // 投影坐标系辅助对象
  vec4 projectionHelper = ProjectionHelper(coord, 1., vec4(vec3(0.2), 1), vec4(vec3(0.2), 1), vec4(vec3(.4), 1), vec4(vec3(.6), 1));

  // 最终的颜色
  fragColor = projectionHelper;
}