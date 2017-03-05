require 'Qt'

class TableWidgetFactory < Qt::Widget

	def self.create rows, type = nil, headers = nil
		
		@rows = rows
		@headers = headers || rows.first.class.column_names
		@headers.push "actions"
		@columns  = @headers.map { |header| header.parameterize.underscore } 
		
		@table = type.blank? ?  Qt::TableWidget.new : type.constantize.new(rows)

		@table.row_count  = rows.size
		@table.column_count = @headers.size 
		
		@table.setHorizontalHeaderLabels headers
		@table.verticalHeader.setVisible false
		@table.setSelectionBehavior Qt::AbstractItemView::SelectRows
		@table.setSelectionMode Qt::AbstractItemView::SingleSelection
		self.populate
		
		@table
	end

	def self.populate 
		@rows.each_with_index do |row, row_index|
			@columns.each_with_index do |column, col_index|
				if column != "actions"
					data = row.send(column).to_s
					
					item = Qt::TableWidgetItem.new data
					#@table.setCellWidget(row_index, col_index, label)
					@table.setItem(row_index, col_index, item)
				else

					@table.add_buttons row_index, col_index if @table.respond_to? :add_buttons
				end
	
					#@table.connect(SIGNAL(pressed (const QModelIndex &))) { puts @table.currentItem.column}
				
      			#$qApp.connect(label, SIGNAL('clicked()'),  $qApp, SLOT('quit'))
      			#label.clicked.connect {|index|}
      			
			end	
		end
	end

	def self.adapt_data_type value
		value = value.to_i unless Integer(value) rescue false == false
		value
	end


end

