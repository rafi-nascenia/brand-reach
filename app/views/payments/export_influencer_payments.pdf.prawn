prawn_document(:page_layout => :landscape) do |pdf|

 pdf.image "#{Rails.root}/app/assets/images/Logo.png", :fit => [99, 78]

 pdf.bounding_box [pdf.bounds.left, pdf.bounds.top - 10], :width  => pdf.bounds.width - 45 do
             pdf.text "Payment Report", :size => 18, align: :right, color: '5D5D5D'
  end

 pdf.stroke do
     pdf.stroke_color 'C0C0C0'
     pdf.move_down 30
     pdf.horizontal_line 0, 725, :at => pdf.bounds.top - 50
 end

 pdf.move_down(20)

 table_data= [['Date Billed', 'Transaction ID', 'Amount Received(INR)', 'Payment Status']]

 @influencer_payments.each do |payment|
    table_data << [
                    payment.billed_date.present? ? payment.billed_date.strftime('%B %d, %Y') : 'NA',
                    sprintf('BP%05d',payment.id),
                    payment.amount_billed,
                    payment.status
                  ]
 end

 pdf.table(table_data, :column_widths => [275, 150, 150, 150], :cell_style => { inline_format: true,border_color: 'C0C0C0', padding: 4, align: :center, font: 'Helvetica', text_color: '5D5D5D', size: 12 }) do
          self.row_colors = %w(FFFFFF f6f6f6)
          row(0).background_color = 'D9D9D9'
          row(0).size = 13
          self.header = true
   end

   # pdf.repeat :all do
        pdf.bounding_box [pdf.bounds.left, pdf.bounds.bottom + 15], :width  => pdf.bounds.width - 20 do
         pdf.stroke_horizontal_rule
         pdf.move_down(6)
         pdf.text @footer_text, :size => 9, align: :center, color: '5D5D5D'
       end
   # end
end