require "zip"
require "csv-diff"
require "csv"
require "open-uri"

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
    starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    # TODO Possible steps
    # verify when was the last update so it's not done more than once per day

    # download_data
    download_zip

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

    # TODO should respond before???
    head(:no_content)
  end

  private
  def download_zip
    # TODO use curl or wget???
    begin
      IO.copy_stream(URI.open(Rails.configuration.dataset_url), "dataset/new.zip")
    rescue Errno::ENOTDIR, Errno::ENOENT
      Dir.mkdir("dataset")
      retry
    end
  end

  def unzip_data
    Zip::File.open("dataset/new.zip") do |zip_file|
      # We assume the zip only has 1 csv file
      zip_file.first.extract "dataset/new.csv"
    end
  end

  def get_diff
    new_file = CSV.open("dataset/new.csv", "r") do |csv|
      csv.readlines
    end

    begin
      old_file = CSV.open("dataset/old.csv", "r") do |csv|
        csv.readlines
      end
    rescue Errno::ENOENT
      # If there is no old.csv file then all the data is new
      # TODO better way to return the new data without calling CSVDiff.new
      old_file = [new_file.first]
    end

    diff = CSVDiff.new(old_file, new_file)

    diff.adds
  end

  def save_diff(diff)
    # TODO add batch size to ENV
    diff.each_slice(20) do |batch|
      cases = batch.map do |_, value|
        {
          event_id: value.fields["id_evento_caso"],
          gender: value.fields["sexo"],
          # TODO "edad" could be in months. based on edad_años_meses, if it is in months it should be transformed to years
          age: value.fields["edad"],
          state: value.fields["residencia_provincia_nombre"],
          diagnosis_date: value.fields["fecha_diagnostico"],
          death_date: value.fields["fecha_fallecimiento"]
        }
      end

      Case.insert_all!(cases)
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
    File.delete("dataset/new.zip")
    File.delete("dataset/old.csv") if File.exist?("dataset/old.csv")
  end

  def rename_csv
    File.rename("dataset/new.csv", "dataset/old.csv")
  end
end
