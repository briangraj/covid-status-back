require "zip"
require "csv-diff"
require "csv"

class UpdatesController < ApplicationController
  def show
    @update = Update.select(:last_load_date, :updated_records).last

    # TODO generalize for any object
    msg = {
      lastLoadDate: @update.last_load_date,
      updatedRecords: @update.updated_records
    }

    render json: msg, status: :ok
  end

  def update_migration
    # TODO Possible steps
    # verify when was the last update so it's not done more than once per day

    # download_data

    # unzip_data
    unzip_data

    # get_diff
    diff = get_diff

    # save_diff
    save_diff(diff)

    # save_to_update
    update_sync_data(diff)

    # delete_downloaded_zip_and_csv
    delete_files

    # rename_csv
    rename_csv

    head(:no_content)
  end

  private
  def unzip_data
    Zip::File.open("datasets/10-casos.zip") do |zip_file|
      # Handle entries one by one
      zip_file.each do |entry|
        puts "Extracting #{entry.name}"

        # Extract to file or directory based on name in the archive
        begin
          entry.extract "zips/" + entry.name
        rescue Errno::ENOTDIR, Errno::ENOENT => err
          Dir.mkdir "zips"
          retry
        end
      end
    end
  end

  def get_diff
    file1 = CSV.open("zips/10-casos.csv", "r") do |csv|
      csv.readlines
    end
    file2 = CSV.open("zips/11-casos.csv", "r") do |csv|
      csv.readlines
    end
    diff = CSVDiff.new(file1, file2)

    diff.adds
  end

  def save_diff(diff)
    diff.each do |_, value|
      # TODO not save one by one
      a_case = Case.new(
        event_id: value.fields["id_evento_caso"],
        gender: value.fields["sexo"],
        # TODO "edad" could be in months. based on edad_años_meses, if it is in months it should be transformed to years
        age: value.fields["edad"],
        state: value.fields["residencia_provincia_nombre"],
        diagnosis_date: value.fields["fecha_diagnostico"],
        death_date: value.fields["fecha_fallecimiento"]
      )

      a_case.save!
    end
  end

  def update_sync_data(diff)
    # TODO only exists one record???
    sync_data = Update.last
    sync_data.last_load_date = Date.today
    sync_data.updated_records = diff.size

    sync_data.save!
  end

  def delete_files
    File.delete("datasets/10-casos.zip")
    File.delete("zips/11-casos.csv")
  end

  def rename_csv
    File.rename("zips/10-casos.csv", "zips/11-casos.csv")
  end
end
