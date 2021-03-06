import os

FRAMERATE = 30

CARLA_CONNECT_TIMEOUT = 4.0

OBS_LIDAR_POINTS = 'lidar_points'
OBS_CAMERA_RGB_IMAGE = 'camera_image'
OBS_POSITION = 'player_pos'
OBS_ACTOR_EGO, OBS_ACTORS_RAW = 'ego_actor', 'all_dynamic_actors'
OBS_GRID_LOCAL, OBS_GRID_COMBINED = 'local_occupancy_grid', 'fused_combined_occupancy_grid'
OBS_GRAPH_LOCAL, OBS_GRAPH_REMOTE = 'local_graph', 'remote_graph'
OBS_GNSS_PREFIX = 'pos_gnss_'

ALIAS_EGO = 'ego'

INCREMENTAL_GRIDS = False  # because buggy
GRID_TTL_SEC = 2  # choose greater than (average effective grid generation rate)^-1 for evaluation

OCCUPANCY_RADIUS_DEFAULT = 10  # (5 and 15 or 10 and 7.5)
OCCUPANCY_BBOX_OFFSET = 0.1
OCCUPANCY_BBOX_HEIGHT = 3.5

LIDAR_ANGLE_DEFAULT = 7.5  # Caution: Choose Lidar angle depending on grid size
LIDAR_MAX_RANGE = 48
LIDAR_Z_OFFSET = 2.8

GNSS_Z_OFFSET = 2.8

RES_X, RES_Y = 1024, 768

MQTT_QOS = 1
TOPIC_GRAPH_RAW_IN = '/graph_raw_in'
TOPIC_PREFIX_GRAPH_FUSED_OUT = '/graph_fused_out'

EDGE_DISTRIBUTION_TILE_LEVEL = 15
REMOTE_GRID_TILE_LEVEL = 19
OCCUPANCY_TILE_LEVEL = 24

FUSION_DECAY_LAMBDA = .14

REMOTE_PSEUDO_ID = -1

RECORDING_RATE = 15  # Hz
RECORDING_FILE_TPL = 'recordings/<id>_%Y-%m-%d_%H-%M-%S.csv'

NPC_TARGET_SPEED = 25  # km/h
EGO_TARGET_SPEED = 25  # km/h

SCENE2_EGO_PREFIX = 'random_hero'
SCENE2_NPC_PREFIX = 'npc'
SCENE2_STATIC_PREFIX = 'static'
SCENE2_N_EGOS = 6
SCENE2_N_VEHICLES = 6
SCENE2_N_PEDESTRIANS = 90
SCENE2_N_STATIC = 75
SCENE2_MAP_NAME = 'Town01'
SCENE2_AREA_CENTER = (180.6, 55.8, .8)  # Town01-specific location
SCENE2_CENTER_DIST = 85.
SCENE2_MIN_REMAINING_EGOS = SCENE2_N_EGOS // 2

MQTT_BASE_HOSTNAME = os.getenv('MQTT_BASE_HOSTNAME', 'localhost')

EVAL2_BASE_KEY = '120203233231202'  # Town01
EVAL2_DATA_DIR = 'evaluation/perception'
