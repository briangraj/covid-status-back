require "zip"

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

    # save_diff

    # save_to_update

    # delete_downloaded_zip

    # rename_csv

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
end
