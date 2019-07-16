from keyboard_control import KeyboardControl

import carla
from .strategy import Strategy


class ManualStrategy(Strategy):
    def __init__(self):
        self.controller: KeyboardControl = None
        super().__init__()

    def init(self, subject):
        super().init(subject)

    def step(self, clock=None) -> bool:
        if self.subject is None:
            return False

        if not self.controller:
            self.controller = KeyboardControl(self.subject, False)

        return self.controller.parse_events(self.subject, clock)

    def spawn(self) -> carla.Vehicle:
        blueprint = self.subject.world.get_blueprint_library().filter('vehicle.tesla.model3')[0]
        blueprint.set_attribute('role_name', self.subject.name)
        if blueprint.has_attribute('color'):
            color = blueprint.get_attribute('color').recommended_values[0]
            blueprint.set_attribute('color', color)

        spawn_point = carla.Transform(carla.Location(x=-155.2, y=-36.1, z=1.5), carla.Rotation(yaw=180))

        return self.subject.world.spawn_actor(blueprint, spawn_point)