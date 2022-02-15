import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function() onSubmitted;
  final Function() onReset;
  final Function(Map<String, Object>) onChange;
  final Map<String, Object> options;

  const SearchBar({
    Key? key,
    required this.onSubmitted,
    required this.onChange,
    required this.options,
    required this.onReset,
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              icon: Icon(Icons.search),
            ),
            onChanged: (value) => widget.onChange({'name': value}),
            onSubmitted: (String value) {
              widget.onSubmitted();
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              DropdownButton(
                value: widget.options["gen"],
                items: const [
                  DropdownMenuItem(
                    child: Text('Generation - All'),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 1'),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 2'),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 3'),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 4'),
                    value: 4,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 5'),
                    value: 5,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 6'),
                    value: 6,
                  ),
                  DropdownMenuItem(
                    child: Text('Generation 7'),
                    value: 7,
                  ),
                ],
                onChanged: (value) => widget.onChange({'gen': value!}),
              ),
              const SizedBox(width: 8),
              DropdownButton(
                value: widget.options["sortBy"],
                items: const [
                  DropdownMenuItem(
                    child: Text('Sort By - ID'),
                    value: 'id',
                  ),
                  DropdownMenuItem(
                    child: Text('Sort By - Name'),
                    value: 'name',
                  ),
                  DropdownMenuItem(
                    child: Text('Sort By - Height'),
                    value: 'height',
                  ),
                  DropdownMenuItem(
                    child: Text('Sort By - Weight'),
                    value: 'weight',
                  ),
                  DropdownMenuItem(
                    child: Text('Sort By - Base Exp'),
                    value: 'base_experience',
                  ),
                ],
                onChanged: (value) => widget.onChange({'sortBy': value!}),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: widget.options["order"],
                items: const [
                  DropdownMenuItem(
                      child: Text('Order - Ascending'), value: 'asc'),
                  DropdownMenuItem(
                      child: Text('Order - Descending'), value: 'desc'),
                ],
                onChanged: (val) => widget.onChange({'order': val!}),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: const Text('Apply Filters'),
                  onPressed: widget.onSubmitted,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  child: const Text('Reset'),
                  onPressed: () => widget.onReset(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
