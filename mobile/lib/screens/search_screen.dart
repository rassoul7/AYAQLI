import 'package:flutter/material.dart';

import '../models/mock_data.dart';
import '../models/verse.dart';
import '../services/api_client.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/concept_chip.dart';
import '../widgets/theme_toggle_button.dart';
import '../widgets/verse_card.dart';
import 'verse_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _apiClient = ApiClient();
  final _controller = TextEditingController();

  List<SearchResult> _results = [];
  bool _loading = false;
  String? _error;
  bool _searchedOnce = false;
  String? _activeConcept;

  Future<void> _runSearch(String query) async {
    if (query.trim().length < 2) return;

    setState(() {
      _loading = true;
      _error = null;
      _searchedOnce = true;
    });

    try {
      final results = await _apiClient.search(query.trim());
      setState(() => _results = results);
    } catch (e) {
      setState(() => _error = 'Impossible de contacter le serveur Ayaqli. Vérifie que le backend tourne (voir backend/README.md).');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onConceptTap(String concept) {
    if (_activeConcept == concept) {
      setState(() => _activeConcept = null);
      _controller.clear();
      return;
    }
    setState(() {
      _activeConcept = concept;
      _controller.text = concept;
    });
    _runSearch(concept);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ayaqli', style: latinFont(size: 22, weight: FontWeight.w700, color: c.text)),
                const ThemeToggleButton(),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: c.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: c.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 18, color: c.textFaint),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (q) {
                        setState(() => _activeConcept = null);
                        _runSearch(q);
                      },
                      style: latinFont(size: 15, color: c.text),
                      decoration: InputDecoration(
                        hintText: 'Search a concept: patience, marriage, justice…',
                        hintStyle: latinFont(size: 13.5, color: c.textFaint),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mockConcepts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final concept = mockConcepts[i];
                  return ConceptChip(
                    label: concept,
                    active: _activeConcept == concept,
                    onTap: () => _onConceptTap(concept),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            if (_searchedOnce && !_loading && _error == null)
              Text('${_results.length} résultat${_results.length > 1 ? 's' : ''}', style: latinFont(size: 12, color: c.textFaint)),
            const SizedBox(height: 8),
            if (_loading) Padding(padding: const EdgeInsets.only(top: 24), child: Center(child: CircularProgressIndicator(color: c.primary))),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(_error!, style: latinFont(size: 13, color: c.wrongAnswer)),
              ),
            if (!_loading && _error == null && _searchedOnce && _results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('Aucun verset trouvé pour cette recherche.', style: latinFont(size: 13.5, color: c.textFaint))),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final result = _results[index];
                  return VerseCard(
                    verse: result.verse,
                    highlightedTranslation: result.matchedTranslation,
                    concept: _activeConcept,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VerseDetailScreen(verse: result.verse, concept: _activeConcept),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
