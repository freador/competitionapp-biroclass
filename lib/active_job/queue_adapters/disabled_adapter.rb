# Adapter that swallows any enqueued job so background processing stays off.
module ActiveJob
  module QueueAdapters
    class DisabledAdapter
      def enqueue(job)
        log_drop(job)
      end

      def enqueue_at(job, _timestamp)
        log_drop(job)
      end

      private

      def log_drop(job)
        Rails.logger.debug("[ActiveJob::DisabledAdapter] Dropping #{job.class.name} (#{job.job_id})")
      rescue StandardError
        nil
      end
    end
  end
end
