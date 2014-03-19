desc 'parse rank data'

task :reset_user => :environment do
  User.delete_all
end
