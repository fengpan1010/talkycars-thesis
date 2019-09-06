#!python
#cython: boundscheck=False
#cython: wraparound=False
#cython: nonecheck=False
#cython: cdivision=True
from libc cimport math

cdef long EARTH_RADIUS = 6378137
cdef (double, double) LATITUDE_RANGE = (-85.05112878, 85.05112878)
cdef (double, double) LONGITUDE_RANGE = (-180., 180.)

ctypedef enum tile_anchor:
    ANCHOR_NW
    ANCHOR_NE
    ANCHOR_SW
    ANCHOR_SE
    ANCHOR_CENTER

cdef double clip(const double n, const (double, double)
min_max):
return min(max(n, min_max[0]), min_max[1])

cdef long map_size(const long level):
    cdef unsigned long base = 256
    return base << <unsigned long> level

cpdef double ground_resolution(double lat, const long level):
    lat = clip(lat, LATITUDE_RANGE)
    return math.cos(lat * math.pi / 180) * 2 * math.pi * EARTH_RADIUS / map_size(level)

cpdef (long, long) geo_to_pixel((double, double)
geo, const
long
level):
cdef double lat, lon, x, y, sin_lat
cdef long pixel_x, pixel_y, ms
lat, lon = geo[0], geo[1]
lat = clip(lat, LATITUDE_RANGE)
lon = clip(lon, LONGITUDE_RANGE)
x = (lon + 180) / 360
sin_lat = math.sin(lat * math.pi / 180)
y = 0.5 - math.log((1 + sin_lat) / (1 - sin_lat)) / (4 * math.pi)
ms = map_size(level)
pixel_x = <long> (clip(x * ms + 0.5, (0, ms - 1)))
pixel_y = <long> (clip(y * ms + 0.5, (0, ms - 1)))
return pixel_x, pixel_y

cpdef (double, double) pixel_to_geo((double, double)
pixel, const
long
level):
cdef double x, y, lat, lon, pixel_x, pixel_y
cdef long ms
pixel_x = pixel[0]
pixel_y = pixel[1]
ms = map_size(level)
x = (clip(pixel_x, (0, ms - 1)) / ms) - 0.5
y = 0.5 - (clip(pixel_y, (0, ms - 1)) / ms)
lat = 90 - 360 * math.atan(math.exp(-y * 2 * math.pi)) / math.pi
lon = 360 * x
return math.round(lat * 1e6) / 1e6, math.round(lon * 1e6) / 1e6

cpdef (long, long) pixel_to_tile(const(long, long)
pixel):
return pixel[0] // 256, pixel[1] // 256

cpdef (long, long) tile_to_pixel(const(long, long)
tile, tile_anchor
anchor):
cdef long pixel[2]
pixel = [tile[0] * 256, tile[1] * 256]
if anchor == ANCHOR_CENTER:
    # TODO: should clip on max map size
    pixel = [pixel[0] + 256, pixel[1] + 256]
elif anchor == ANCHOR_NE:
    pixel = [pixel[0] + 256, pixel[1]]
elif anchor == ANCHOR_SW:
    pixel = [pixel[0], pixel[1] + 256]
elif anchor == ANCHOR_SE:
    pixel = [pixel[0] + 256, pixel[1] + 256]

return <long> pixel[0], <long> pixel[1]

cpdef str tile_to_quadkey(const (long, long)
tile, const
long
level):
cdef int i
cdef long tile_x, tile_y, mask, bit
cdef char digit
cdef char qk[level]
tile_x = tile[0]
tile_y = tile[1]
quadkey = ''
for i in range(level):
    bit = level - i
    digit = 48  # ord('0')
    mask = 1 << (bit - 1)  # if (bit - 1) > 0 else 1 >> (bit - 1)
    if (tile_x & mask) is not 0:
        digit += 1
    if (tile_y & mask) is not 0:
        digit += 2
    qk[i] = digit
return qk[:level].decode('UTF-8')

cpdef ((long, long), long) quadkey_to_tile(str
quadkey):
cdef long tile_x, tile_y, mask, bit
cdef int level, i
tile_x, tile_y = (0, 0)
level = len(quadkey)
for i in range(level):
    bit = level - i
    mask = 1 << (bit - 1)
    if quadkey[level - bit] == '1':
        tile_x |= mask
    if quadkey[level - bit] == '2':
        tile_y |= mask
    if quadkey[level - bit] == '3':
        tile_x |= mask
        tile_y |= mask
return (tile_x, tile_y), level
