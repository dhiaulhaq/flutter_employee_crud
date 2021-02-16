import 'package:flutter/material.dart';
import 'Employee.dart';
import 'Services.dart';

class DataTableEmployee extends StatefulWidget {
  DataTableEmployee() : super();
  final String title = 'Flutter Data Table';
  @override
  DataTableEmployeeState createState() => DataTableEmployeeState();
}

class DataTableEmployeeState extends State<DataTableEmployee>{
  List<Employee> _employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  Employee _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;

  @override
  void initState(){
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  //Method to update title in the AppBar title
  _showProgress(String message){
    setState((){
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),),);
  }

  _createTable(){
    _showProgress('Creating Table...');
    Services.createTable().then((result){
      if('success' == result){
        _showSnackBar(context, result);
        _showProgress(widget.title);
      }
    });
  }

  _addEmployee(){
    if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty){
      print('Empty Fields');
      return;
    }
    _showProgress('Adding Data...');
    Services.addEmployee(_firstNameController.text, _lastNameController.text).then((result){
      if('success' == result){
        _getEmployees(); //Refresh list after adding
        _clearValues();
      }
    });
  }

  _getEmployees(){
    _showProgress('Loading Data...');
    Services.getEmployees().then((employees){
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title);
      print("Length ${employees.length}");
    });
  }

  _updateEmployee(Employee employee){
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Data...');
    Services.updateEmployee(employee.id, _firstNameController.text, _lastNameController.text).then((result){
      if('success' == result){
        _getEmployees(); //Refresh list after updating
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee){
    _showProgress('Deleting Data...');
    Services.deleteEmployee(employee.id).then((result){
      if('success' == result){
        _getEmployees(); //Refresh list after deleting
      }
    });
  }

  //Method to clear TextField values
  _clearValues(){
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Employee employee){
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
  }

  //Data Table
  SingleChildScrollView _dataBody(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('ID'),
            ),
            DataColumn(
              label: Text('FIRST NAME'),
            ),
            DataColumn(
              label: Text('LAST NAME'),
            ),
            DataColumn(
              label: Text('DELETE'),
            ),
          ],
          rows: _employees.map(
              (employee) => DataRow(cells: [
                DataCell(
                  Text(employee.id),
                  onTap: (){
                    _showValues(employee);
                    _selectedEmployee = employee;
                    setState(() {
                      _isUpdating = true;
                    });
                  },
                ),
                DataCell(
                  Text(employee.firstName.toUpperCase()),
                  onTap: (){
                    _showValues(employee);
                    _selectedEmployee = employee;
                    setState(() {
                      _isUpdating = true;
                    });
                  },
                ),
                DataCell(
                  Text(employee.lastName.toUpperCase()),
                  onTap: (){
                    _showValues(employee);
                    _selectedEmployee = employee;
                    setState(() {
                      _isUpdating = true;
                    });
                  },
                ),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    _deleteEmployee(employee);
                  },
                ))
              ]),
          ).toList(),
        ),
      ),
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              _getEmployees();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(hintText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(hintText: 'Last Name'),
              ),
            ),
            //Update and Cancel Button
            _isUpdating
                ? Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('UPDATE'),
                  onPressed: (){
                    _updateEmployee(_selectedEmployee);
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: (){
                    setState(() {
                      _isUpdating = false;
                    });
                    _clearValues();
                  },
                ),
              ],
            ) : Container(),
            Expanded(
              child: _dataBody(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }

}
