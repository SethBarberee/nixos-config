{lib, ...}: {
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_stats = true;
      gpu_temp = true;
      gpu_junction_temp = true;
      gpu_core_clock = true;
      gpu_mem_temp = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_value = "60,90";
      gpu_load_color = lib.mkForce "39F900,FDFD09,B22222";
      gpu_fan = true;
      gpu_voltage = true;
      cpu_stats = true;
      cpu_temp = true;
      cpu_mhz = true;
      cpu_load_value = "60,90";
      cpu_load_color = lib.mkForce "39F900,FDFD09,B22222";
      vram = true;
      ram = true;
      fps = true;
      frame_timing = true;
      frametime = true;
      font_scale = lib.mkForce 2.25;
      fps_metrics = "avg,0.01";
      throttling_status = true;
      text_outline = true;
      round_corners = 10;
    };
  };
}
