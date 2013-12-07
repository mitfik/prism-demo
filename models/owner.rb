require 'fileutils'
class Owner
  include DataMapper::Resource

  property :id, Serial
  property :full_name, String, :required => true
  belongs_to :company

  def upload_pdf(file_params, upload_path)
    begin
      filename = file_params[:filename]
      tempfile = file_params[:tempfile]
      file_path = File.join(prepare_upload_zone(upload_path), "#{self.id}.pdf")
      return "File with this name already exist" if pdf_exist?(file_path)
      file = File.open(file_path, "wb")
      file.write(tempfile.read)
      return nil
    rescue => e
      # LOG
      return "Sorry something went wrong, we will try to fix that as soon as possible"
    ensure
      file.close unless file == nil
    end
  end

  def file_path(upload_path)
    file_path = File.join(upload_path, self.company_id.to_s, "#{self.id}.pdf")
    if pdf_exist?(file_path)
      return file_path
    else
      return nil
    end
  end

  private
    # One directory per company
    def prepare_upload_zone(upload_path)
      path = File.join(upload_path, self.company_id.to_s)
      FileUtils.mkpath(path) unless File.directory?(path)
      return path
    end

    def pdf_exist?(filename)
      File.file?(filename)
    end
end
