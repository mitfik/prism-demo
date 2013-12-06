class Company
  include DataMapper::Resource

  property :id, Serial
  property :name, String, :required => true
  property :address, String, :required => true
  property :city, String, :required => true
  property :country, String, :required => true
  property :email, String, :format => :email_address
  property :phone_number, String
  has n, :owners

  def upload_pdf(file_params, upload_path)
    begin
      filename = file_params[:filename]
      tempfile = file_params[:tempfile]
      file_path = File.join(prepare_upload_zone(upload_path), filename)
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

  private
    # One directory per company
    def prepare_upload_zone(upload_path)
      path = File.join(upload_path, id.to_s)
      Dir.mkdir(path) unless File.directory?(path)
      return path
    end

    def pdf_exist?(filename)
      File.file?(filename)
    end
end
