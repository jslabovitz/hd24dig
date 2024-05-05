module HD24Extractor

  class Command < SimpleCommand::Command

    def run(args)
      drive_path = args.shift or raise UsageError, "Must specify drive path"
      @drive = Parts::Drive.open(drive_path)
      drop_privileges
    end

    def drop_privileges
      if ENV['SUDO_USER']   # running under sudo?
        # ;;warn 'dropping privileges'
        Process::Sys.setgid(ENV['SUDO_GID'].to_i)
        Process::Sys.setuid(ENV['SUDO_UID'].to_i)
      end
    end

  end

end