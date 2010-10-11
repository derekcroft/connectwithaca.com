task :import_edifice_trainers => [ :environment ] do
  FasterCSV.foreach("#{Rails.root}/db/import/edifice_trainers.csv", :headers => :first_row) do |row|
    User.destroy_all(:login => row["Email"])
    u = User.create({
      :login => row["Direct Email To:"],
      :name => row["Direct Email To:"],
      :email => row["Direct Email To:"],
      :password => "password",
      :password_confirmation => "password"
    })
    u.create_member( {
      :first_name => row["First Name"],
      :middle_initial => row["Middle"],
      :last_name => row["Last Name"],
      :phone => row["Phone"].gsub(/\D/, ''),
      :email => row["Direct Email To:"],
      :address => row["Ship Cards To:"]
    } )
 end
end

task :import_aca_trainers => [ :environment ] do
  FasterCSV.foreach("#{Rails.root}/db/import/aca_trainers_10102010.csv", :headers => :first_row) do |row|
    User.destroy_all(:login => row["Email"])
    u = User.create({
      :login => row["Email"],
      :name => row["Email"],
      :email => row["Email"],
      :password => "password",
      :password_confirmation => "password"
    })
    u.create_member( {
      :active => row["Active"] == "Yes",
      :last_name => row["Last Name"],
      :first_name => row["First Name"],
      :address => row["Address"],
      :address2 => row["Address 2"],
      :city => row["City"],
      :state => row["State"],
      :zip => row["Zip"],
      :home_phone => row["Home Phone"].try(:gsub, /\D/, ''),
      :mobile_phone => row["Mobile Phone"].try(:gsub, /\D/, ''),
      :url => row["Website"],
      :email => row["ACA email"]
    })
  end
end
