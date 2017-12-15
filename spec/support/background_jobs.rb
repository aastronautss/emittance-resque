# frozen_string_literal: true

module BackgroundJobs
  def run_jobs_inline
    inline = Resque.inline
    Resque.inline = true
    yield
    Resque.inline = inline
  end
end
