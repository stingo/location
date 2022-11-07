class RichTextFigure
  include Rails.application.routes.url_helpers
  attr_accessor :product, :base_url

  def initialize(product_id, base_url)
    @base_url = base_url
    @product = Product.find_by(id: product_id)
  end

  def rich_text_figure
   
    rich_text = '<a href='"#{product_path(product) }"'><div class="seller-messge__attachment">'"#{product.title}"'<figure contenteditable="false" data-trix-attachment="{&quot;contentType&quot;:&quot;image/png&quot;,&quot;filename&quot;:&quot;file_name&quot;,&quot;filesize&quot;:22496,&quot;height&quot;:522,&quot;sgid&quot;:&quot;BAh7CEkiCGdpZAY6BkVUSSI3Z2lkOi8vZS1jb21tZXJjZS9BY3RpdmVTdG9yYWdlOjpCbG9iLzE4P2V4cGlyZXNfaW4GOwBUSSIMcHVycG9zZQY7AFRJIg9hdHRhY2hhYmxlBjsAVEkiD2V4cGlyZXNfYXQGOwBUMA==--eb8d7033286182d470ee424ef9493242cc016b58&quot;,&quot;url&quot;:&quot;blob_path&quot;,&quot;width&quot;:275}" data-trix-content-type="content_type" data-trix-id="158" data-trix-attributes="{&quot;presentation&quot;:&quot;gallery&quot;}" class="attachment attachment--preview attachment--png" data-trix-mutable="true"><img src="blob_path" data-trix-mutable="true" width="275" height="522" data-trix-store-key="imageElement/158/blob_path/275/522"><figcaption class="attachment__caption attachment__caption--editing"><textarea placeholder="Add a caption…" data-trix-mutable="true" class="attachment__caption-editor" style="height: 17px;"></textarea><textarea placeholder="Add a caption…" data-trix-mutable="true" class="attachment__caption-editor trix-autoresize-clone" tabindex="-1"></textarea></figcaption><figcaption class="attachment__caption" style="display: none;"><span class="attachment__name">file_name</span> <span class="attachment__size">file_size KB</span></figcaption><div data-trix-mutable="true" class="attachment__toolbar"><div class="trix-button-row"><span class="trix-button-group trix-button-group--actions"><button title="Remove" data-trix-action="remove" class="trix-button trix-button--remove">Remove</button></span></div><div class="attachment__metadata-container"><span class="attachment__metadata"><span title="file_name" class="attachment__name">file_name</span><span class="attachment__size">'"#{byte_size}"' KB</span></span></div></div></figure><p>'"#{product.price} #{"$"}"'</p><div></a>'
    rich_text.gsub!('blob_path', product_image_path)
    rich_text.gsub!('content_type', blob.content_type)
    rich_text
  end

  private

  def product_image_path
    "#{base_url}#{rails_blob_path(product.product_images.first, only_path: true)}"
  end


  def byte_size
    (blob.byte_size / 1024).round(2).to_s
  end

  def blob
    @blob ||= product.product_images.first.blob
  end
end
