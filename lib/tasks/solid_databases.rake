if defined?(Rake::Task)
  %w[db:prepare db:migrate].each do |db_task|
    next unless Rake::Task.task_defined?(db_task)

    Rake::Task[db_task].enhance do
      %w[cable queue].each do |component|
        task_name = "db:#{component}:prepare"
        next unless Rake::Task.task_defined?(task_name)

        Rake::Task[task_name].invoke
      end
    end
  end
end
