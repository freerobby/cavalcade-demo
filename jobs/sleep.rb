class Sleep < Cavalcade::Job
  @queue = :default
  def self.perform(num_seconds)
    sleep(num_seconds)
  end
end
