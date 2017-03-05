require 'Qt'

class TableWidgetFactory

	def initialize  rows,  headers = nil, parent = 0
		super()
		@rows = rows
		@headers = headers || rows.first.class.column_names
		@columns = @headers.each { |header| header.parameterize.underscore }
		@table = Qt::TableWidget.new
		@table.row_count  = rows.size
		@table.column_count = @headers.size 
		
		@table.setHorizontalHeaderLabels headers
		@table.verticalHeader.setVisible false
		@table.setSelectionBehavior Qt::AbstractItemView::SelectRows
		@table.setSelectionMode Qt::AbstractItemView::SingleSelection
		populate
	end

	def self.call rows,  headers = nil, parent = 0
		self.new
		@table
	end

	def populate
		@rows.each_with_index do |row, row_index|
			@columns.each_with_index do |column, col_index|
				
				@table.setItem(row_index, col_index, Qt::TableWidgetItem.new("Hello"))
			end
		end
	end
end