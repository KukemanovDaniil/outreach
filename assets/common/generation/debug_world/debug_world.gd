extends VoxelGeneratorScript

const _CHANNEL = VoxelBuffer.CHANNEL_TYPE

@export var block_lib : VoxelBlockyLibrary
@export var grid_step: int = 2
@export var target_y: int = 0

@export var dirt_id: int = 2
@export var stone_id: int = 3

func _get_used_channels_mask() -> int:
	return 1 << _CHANNEL

func _generate_block(buffer: VoxelBuffer, origin: Vector3i, _lod: int) -> void:
	if block_lib == null: return
	
	if target_y < origin.y or target_y >= origin.y + buffer.get_size().y:
		return

	var size = buffer.get_size()
	var local_y = target_y - origin.y
	
	var models_count = block_lib.models.size()
	var row_width = int(ceil(sqrt(float(models_count))))
	var grid_end_x = row_width * grid_step
	
	var gap = 1
	var plat_size = 32

	var d_start_x = grid_end_x + gap - 1
	var d_end_x = d_start_x + plat_size
	_fill_platform(buffer, origin, local_y, d_start_x, d_end_x, 0, plat_size, dirt_id)
	
	var s_start_x = d_end_x + gap
	var s_end_x = s_start_x + plat_size
	_fill_platform(buffer, origin, local_y, s_start_x, s_end_x, 0, plat_size, stone_id)

	var inv_step = 1.0 / grid_step
	var start_x = (grid_step - (origin.x % grid_step)) % grid_step
	var start_z = (grid_step - (origin.z % grid_step)) % grid_step

	var z = start_z
	while z < size.z:
		var wz = origin.z + z
		var gz = int(float(wz) * inv_step)
		if gz >= 0 and gz < row_width:
			var z_offset = gz * row_width
			var x = start_x
			while x < size.x:
				var wx = origin.x + x
				var gx = int(float(wx) * inv_step)
				if gx >= 0 and gx < row_width:
					var block_index = gx + z_offset
					if block_index < models_count:
						buffer.set_voxel(block_index + 1, x, local_y, z, _CHANNEL)
				x += grid_step
		z += grid_step

func _fill_platform(buffer: VoxelBuffer, origin: Vector3i, local_y: int, x_min: int, x_max: int, z_min: int, z_max: int, block_id: int):
	var size = buffer.get_size()
	
	var lo_x = x_min - origin.x
	var hi_x = x_max - origin.x
	var lo_z = z_min - origin.z
	var hi_z = z_max - origin.z
	
	var clip_x_start = clamp(lo_x, 0, size.x)
	var clip_x_end = clamp(hi_x, 0, size.x)
	var clip_z_start = clamp(lo_z, 0, size.z)
	var clip_z_end = clamp(hi_z, 0, size.z)
	
	if clip_x_start < clip_x_end and clip_z_start < clip_z_end:
		buffer.fill_area(
			block_id, 
			Vector3i(clip_x_start, local_y, clip_z_start), 
			Vector3i(clip_x_end, local_y + 1, clip_z_end), 
			_CHANNEL
		)
