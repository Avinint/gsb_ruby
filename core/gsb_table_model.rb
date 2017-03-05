class GSBTableModel < Qt::AbstractTableModel
    def initialize(rows, columns = nil)
        super()
        @rows = rows
        @headers = columns || @rows.first.class.column_names
        @columns = @headers.each {|header| header.parameterize.underscore}
        
    end

    def rowCount(parent = Qt::ModelIndex.new)
        @rows.size
    end

    def columnCount(parent = Qt::ModelIndex.new)
    	@columns.count
    end

    def data(index, role=Qt::DisplayRole)
        invalid = Qt::Variant.new

        return invalid if !index.valid?

        return invalid unless role == Qt::DisplayRole
        row = @rows[index.row]

        return invalid if row.nil?
        value = row.send @columns[index.column] unless index.column > @columns.size
        
        return Qt::Variant.new("value")
    end

    def headerData(section, orientation, role=Qt::DisplayRole)
        invalid = Qt::Variant.new
        return invalid unless role == Qt::DisplayRole
        value = orientation == Qt::Horizontal ?  @headers[section] :  " "
         
        return Qt::Variant.new(value)
    end

    def flags(index)
        if !index.valid?
                return Qt::ItemIsEnabled
        end
        return super(index)
    end

    def setData(index, variant, role=Qt::EditRole)
        if index.valid? and role == Qt::EditRole
            value = variant.toString
            row = @rows[index.row]

            value = value.to_i unless Integer(value) rescue false == false
            puts "#{@columns[index.column]}="
           
        	row.send("#{@columns[index.column]}=", value) unless index.column > @columns.size
            
            row.save

            emit dataChanged(index, index)
            return true
        else
            return false
        end
    end
end