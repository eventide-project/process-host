require_relative '../automated_init'

context "Signal Handling" do
  supervisor_address = nil

  host = Host.new
  host.start do |supervisor|
    supervisor_address = supervisor.address
    raise StopIteration
  end

  context "Ruby process is sent TSTP (ctrl+Z) signal" do
    host.signal.simulate_signal 'TSTP'

    test "Suspend message is sent to supervior" do
      assert host.send do
        sent? :suspend, address: supervisor_address
      end
    end
  end

  context "Ruby process is sent CONT signal" do
    host.signal.simulate_signal 'CONT'

    test "Resume message is sent to supervior" do
      assert host.send do
        sent? :resume, address: supervisor_address
      end
    end
  end

  context "Ruby process is sent INT signal" do
    host.signal.simulate_signal 'INT'

    test "Shutdown message is sent to supervior" do
      assert host.send do
        sent? :shutdown, address: supervisor_address
      end
    end
  end
end