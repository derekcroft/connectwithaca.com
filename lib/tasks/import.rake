task :import_edifice_trainers => [ :environment ] do
  FasterCSV.foreach("#{Rails.root}/db/import/edifice_trainers.csv", :headers => :first_row) do |row|
    Member.create( {
      :first_name => row["First Name"],
      :middle_initial => row["Middle"],
      :last_name => row["Last Name"],
      :phone => row["Phone"].gsub(/\D/, ''),
      :email => row["Direct Email To:"],
      :address => row["Ship Cards To:"]
    } )
  end
end
