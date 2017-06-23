require './worker.rb'
require 'daemon_spawn'

class AppDaemon < DaemonSpawn::Base

  def start(args)
    info = "service start : #{Time.now}"
    Output.info(info)
    Worker.new({}).run()
  end

  def stop
    info = "service stop  : #{Time.now}"
    Output.info(info)
  end
end

dir = File.expand_path('./', __dir__)
AppDaemon.spawn!(
                :processes => Const.config['daemon_processe'],# 起動プロセス数
                :log_file => dir  + Const.config['daemon_log']['read'],
                :pid_file => "/var/run/read_memec_daemon.pid",
                :sync_log => true,
                :working_dir => File.dirname(__FILE__))